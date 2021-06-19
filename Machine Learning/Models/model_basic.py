#!/usr/bin/env python
# coding: utf-8

# In[12]:


import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor, RandomForestClassifier
from sklearn.linear_model import LogisticRegression
import numpy as np

class Model:
    def __init__(self, datafile, model_type=None):
        self.df = pd.read_csv("nasa.csv")
        if model_type=='rf':
            self.user_defined_model = RandomForestClassifier(oob_score=True)
        else:
            self.user_defined_model = LogisticRegression(random_state=42)

    def split(self, test_size):
        X = self.df.drop(columns=[])
        y = self.df[]
        self.X_train, self.X_test, self.y_train, self.y_test = train_test_split(X, y, test_size = test_size, random_state = 42, shuffle=True)

    def fit(self):
        self.model = self.user_defined_model.fit(self.X_train, self.y_train)
    
    def predict(self):
        result = self.user_defined_model.predict(self.X_test)
        return result

    def transform(self, df):
        date = ['Close Approach Date', 'Orbit Determination Date']
        new_df = df.copy()
      



        if __name__ == '__main__':
    model_instance = Model("nasa", model_type='rf')
    model_instance.split(0.2)
    model_instance.fit()
    model_instance.predict()
    print("Accuracy: ",     model_instance.model.score(model_instance.X_test, model_instance.y_test))


# In[ ]:




