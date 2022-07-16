# Implementation of logistics regression from scratch
A notebook with implementation of logistic regression in a docker environment. Notebook includes:

* data preprocessing
* development of the model (logistic regression)
* tuning of the model (GridSearchCV)
* evaluation of model performance (confusion matrix, ROC)

**Dataset:** Palmer Penguin

**Python library:** scikit-learn


# How to run the notebook?

**Option 1** 

If you have a docker installed :whale:, just create a docker image (in a repo root): `make -f Makefile.docker lab`

Next, go to local host and open notebook there: `http://localhost:8888` (password: logreg) 

**Option 2** 

If you do not have docker on your PC, you can just open notebook using Google Colab or Jupyter. In that case, do not forget to install necessary packages (detailed instructions in the notebook)
