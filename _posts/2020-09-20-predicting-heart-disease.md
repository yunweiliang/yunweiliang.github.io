---
layout: post
title:  "Predicting Risk of Heart Disease with Different ML Models"
date:   2020-09-20

categories: Projects
---

CSE 163 Intermediate Data Programming (Winter 2020). I teamed up with two other classmates for the final project. Our [assignment](https://courses.cs.washington.edu/courses/cse163/20wi/project/overview.html) was to investigate a research question by exercising the Python skills we have learned. 

Looking at the machine learning projects online for ideas, we stumbled upon research done by C. Beulah Christalin Latha and S. Carolin Jeeva on “Improving the accuracy of prediction of heart disease risk based on ensemble classification techniques” ([publication](https://www.sciencedirect.com/science/article/pii/S235291481830217X)). We decided to use the same [Cleveland Heart Disease Dataset](https://archive.ics.uci.edu/ml/datasets/Heart+Disease) that this study was conducted on. 

We chose to investigate the same problem space in a different capacity. Instead of perfecting a model to predict risk of heart disease, we wanted to:

1. Compare three existing classification models in the sklearn package (which we learned from class) and
2. Find the determinant feature in impacting the accuracy of the prediction model.

Together, each of us implemented an ML model: Decision Tree Classifier, Random Forest Classifier, or Naive Bayes Classifier. In order to compare them, I was in charge of running a large amount of trials to find the average accuracy for each model. 

In hindsight, I shouldn't have channeled my inner Java child and for-looped each trial 50 times in main(). 

Fortunately, I saw that this is inefficient. I regained my senses and called upon a year of leetcode practice. I redesigned the class to compartmentalize different functionalities, specifically for answering the first (comparing models) vs. the second question (finding feature). To automate the trials, I edited many methods to be able to run many times while recording its results to be integrated into the graphing methods.  

Before Covid-19 enforced social distancing, we met up everyday in crowded undergrad libraries, apartment spaces, business school cafe, powered by Vietnamese rice cakes and ramen (a rare occasion energized not with lattes). Our 20-page report missed a point for overlooking a line of function comment. We didn't dwell on it.


[Report: "Predicting an Individual’s Risk of Heart Disease Using Various Machine Learning Models"](../../../../assets/Project_Part_2.pdf)

[Repository](https://github.com/yunweiliang/cse163-final-project) (see analyze_ml_models.py and main.py.)
