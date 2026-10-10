#!/usr/bin/env ruby
# Invite-only research papers.
#
# The site's repo is public, so papers are never committed as plain text.
# Write them as Markdown in _research/ (git-ignored), then run:
#
#   bundle exec ruby tools/research.rb lock
#
# That encrypts each paper with the invite code and writes the encrypted
# pages to research/, which is what gets committed and published. Visitors
# type the code on the page and their browser decrypts it.
#
# To get the Markdown back (on a new machine, or to edit a paper):
#
#   bundle exec ruby tools/research.rb unlock
#
# The invite code is read from RESEARCH_CODE or asked for at the prompt.
# It is never stored in the repo. Codes ignore case and extra spaces.
#
# Each file in _research/ is "<slug>.md" with front matter like:
#
#   ---
#   title: Surprising, yet inevitable
#   date: 2026-10-12
#   summary: One sentence for the list page.   (optional)
#   subtitle: Shown under the title.           (optional)
#   placeholder: true                          (optional)
#   ---

require "base64"
require "date"
require "fileutils"
require "io/console"
require "json"
require "openssl"
require "yaml"
require "kramdown"
require "kramdown-parser-gfm"

ROOT = File.expand_path("..", __dir__)
SOURCE_DIR = File.join(ROOT, "_research")
OUTPUT_DIR = File.join(ROOT, "research")
ITERATIONS = 100_000

# Same options GitHub Pages' Jekyll uses with this site's _config.yml.
KRAMDOWN = {
  input: "GFM",
  auto_ids: true,
  hard_wrap: false,
  footnote_backlink: "&#8617;&#xFE0E;",
  smart_quotes: "lsquo,rsquo,ldquo,rdquo",
  syntax_highlighter: nil
}.freeze

def normalize(code)
  code.strip.downcase.split.join(" ")
end

def read_code
  code = ENV["RESEARCH_CODE"]
  if code.nil? || code.strip.empty?
    print "Invite code: "
    code = $stdin.noecho(&:gets).to_s
    puts
  end
  code = normalize(code)
  abort "No invite code given." if code.empty?
  code
end

def derive_key(code, salt)
  OpenSSL::KDF.pbkdf2_hmac(code, salt: salt, iterations: ITERATIONS, length: 32, hash: "sha256")
end

# AES-256-GCM, laid out the way the browser's Web Crypto API expects
# (ciphertext followed by the 16-byte tag).
def encrypt(code, data)
  salt = OpenSSL::Random.random_bytes(16)
  iv = OpenSSL::Random.random_bytes(12)
  cipher = OpenSSL::Cipher.new("aes-256-gcm").encrypt
  cipher.key = derive_key(code, salt)
  cipher.iv = iv
  sealed = cipher.update(JSON.generate(data)) + cipher.final + cipher.auth_tag
  {
    "iterations" => ITERATIONS,
    "salt" => Base64.strict_encode64(salt),
    "iv" => Base64.strict_encode64(iv),
    "data" => Base64.strict_encode64(sealed)
  }
end

def decrypt(code, payload)
  sealed = Base64.strict_decode64(payload["data"])
  cipher = OpenSSL::Cipher.new("aes-256-gcm").decrypt
  cipher.key = OpenSSL::KDF.pbkdf2_hmac(code, salt: Base64.strict_decode64(payload["salt"]),
                                        iterations: payload["iterations"], length: 32, hash: "sha256")
  cipher.iv = Base64.strict_decode64(payload["iv"])
  cipher.auth_tag = sealed[-16..]
  JSON.parse(cipher.update(sealed[0...-16]) + cipher.final)
rescue OpenSSL::Cipher::CipherError
  abort "That invite code doesn't open the existing papers."
end

def esc(text)
  text.to_s.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;").gsub('"', "&quot;")
end

def read_paper(path)
  source = File.read(path)
  match = source.match(/\A---\s*\n(.*?)\n---\s*\n(.*)\z/m)
  abort "#{path} needs front matter (--- title: ... ---)." unless match
  meta = YAML.safe_load(match[1], permitted_classes: [Date]) || {}
  abort "#{path} needs a title." unless meta["title"]
  date = meta["date"] ? Date.parse(meta["date"].to_s) : Date.today
  {
    "slug" => File.basename(path, ".md"),
    "title" => meta["title"].to_s,
    "subtitle" => meta["subtitle"],
    "summary" => meta["summary"],
    "placeholder" => meta["placeholder"] == true,
    "date" => date,
    "body" => Kramdown::Document.new(match[2], KRAMDOWN).to_html,
    "source" => source
  }
end

# Mirrors _includes/toc.html: a contents list when there are 2+ sections.
def toc(html)
  sections = html.scan(%r{<h2 id="([^"]+)">(.*?)</h2>}m)
  return "" if sections.size < 2
  items = sections.map { |id, label| %(<li><a href="##{id}">#{label.gsub(/<[^>]+>/, "")}</a></li>) }
  %(<nav class="toc" aria-labelledby="toc-title"><h2 id="toc-title" class="toc-title">Contents</h2><ol>#{items.join}</ol></nav>)
end

def time_tag(date)
  %(<time datetime="#{date.iso8601}">#{date.strftime("%B %-d, %Y")}</time>)
end

# Mirrors _layouts/essay.html.
def paper_html(paper)
  parts = [%(<article class="essay"><header class="essay-header"><h1 tabindex="-1">#{esc(paper["title"])}</h1>)]
  parts << %(<p class="subtitle">#{esc(paper["subtitle"])}</p>) if paper["subtitle"]
  parts << %(<p class="meta">#{time_tag(paper["date"])}</p></header>)
  if paper["placeholder"]
    parts << %(<p class="notice" role="note"><strong>Placeholder.</strong> This paper is sample text showing the layout. It will be replaced with a real paper.</p>)
  end
  parts << toc(paper["body"])
  parts << %(<div class="prose">#{paper["body"]}</div></article>)
  parts.join
end

# Mirrors the essay list on the home page.
def index_html(papers)
  items = papers.map do |paper|
    summary = paper["summary"] ? "<p>#{esc(paper["summary"])}</p>" : ""
    %(<li><a href="/research/#{paper["slug"]}/">#{esc(paper["title"])}</a>#{summary}<p class="meta">#{time_tag(paper["date"])}</p></li>)
  end
  %(<section class="home"><h1 tabindex="-1">Research</h1><ul class="essay-list">#{items.join}</ul></section>)
end

def write_page(dir, payload)
  FileUtils.mkdir_p(dir)
  File.write(File.join(dir, "index.html"), <<~HTML)
    ---
    layout: locked
    title: Research
    ---
    <script type="application/json" id="locked-payload">#{JSON.generate(payload)}</script>
  HTML
end

def lock
  sources = Dir[File.join(SOURCE_DIR, "*.md")].sort
  if sources.empty?
    abort "No papers in _research/. To edit existing papers, run `unlock` first."
  end
  code = read_code
  papers = sources.map { |path| read_paper(path) }.sort_by { |paper| paper["date"] }.reverse

  FileUtils.rm_rf(OUTPUT_DIR)
  write_page(OUTPUT_DIR, encrypt(code, "title" => "Research", "html" => index_html(papers)))
  papers.each do |paper|
    data = { "title" => paper["title"], "html" => paper_html(paper), "source" => paper["source"] }
    write_page(File.join(OUTPUT_DIR, paper["slug"]), encrypt(code, data))
  end
  puts "Encrypted #{papers.size} paper(s) into research/."
end

def unlock
  pages = Dir[File.join(OUTPUT_DIR, "*", "index.html")].sort
  abort "No encrypted papers in research/." if pages.empty?
  code = read_code
  FileUtils.mkdir_p(SOURCE_DIR)
  pages.each do |page|
    json = File.read(page)[%r{<script type="application/json" id="locked-payload">(.*)</script>}m, 1]
    slug = File.basename(File.dirname(page))
    File.write(File.join(SOURCE_DIR, "#{slug}.md"), decrypt(code, JSON.parse(json))["source"])
  end
  puts "Restored #{pages.size} paper(s) into _research/."
end

case ARGV.first
when "lock" then lock
when "unlock" then unlock
else abort "Usage: bundle exec ruby tools/research.rb lock|unlock"
end
