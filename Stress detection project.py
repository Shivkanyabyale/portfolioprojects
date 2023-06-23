#!/usr/bin/env python
# coding: utf-8

# In[2]:


import numpy as np
import pandas as pd
import seaborn as sns
from matplotlib import pyplot as plt
from sklearn.naive_bayes import BernoulliNB
from sklearn.feature_extraction.text import CountVectorizer


# In[4]:


df=pd.read_csv("C:/Users/shivk/OneDrive/Desktop/spam.csv",encoding="latin-1")


# In[5]:


#dataset visiulization
df.head(n=10)


# In[7]:


df.shape


# In[8]:


#to check wether the target attribute is binary or not 
np.unique(df["class"])


# In[9]:


np.unique(df["message"])it is textual deta thus we have to apply count method on it
#


# In[11]:


#creating sparse matrix
x=df["message"].values
y=df["class"].values

#creating count vectoriser object
cv=CountVectorizer()

x=cv.fit_transform(x)
v=x.toarray()
print(v)


# In[12]:


first_col=df.pop("message")
df.insert(0,"message",first_col)
df


# In[13]:


#spliting train +test 3:1
train_x=x[:4180]
train_y=y[:4180]

test_x=x[4180:]
test_y=y[4180:]


# In[16]:


#binarisation--process of binarizing data
bnb=BernoulliNB(binarize=0.0)
model=bnb.fit(train_x,train_y)

y_pred_train=bnb.predict(train_x)
y_pred_test=bnb.predict(test_x)


# In[17]:


#training score
print(bnb.score(train_x,train_y)*100)

#testing score
print(bnb.score(test_x,test_y)*100)


# In[19]:


from sklearn.metrics import classification_report
print(classification_report(train_y,y_pred_train))


# In[20]:


from sklearn.metrics import classification_report
print(classification_report(test_y,y_pred_test))


# In[ ]:


import numpy as np
import pandas as pd


# In[4]:


df=pd.read_csv("C:/Users/shivk/OneDrive/Desktop/stress.csv")
df.head()


# In[6]:


df.describe()


# In[8]:


df.isnull().sum()


# In[10]:


import nltk
import re
from nltk. corpus import stopwords
import string
nltk. download( 'stopwords' )
stemmer = nltk. SnowballStemmer("english")
stopword=set (stopwords . words ( 'english' ))

def clean(text):
    text = str(text) . lower()  #returns a string where all characters are lower case. Symbols and Numbers are ignored.
    text = re. sub('\[.*?\]',' ',text)  #substring and returns a string with replaced values.
    text = re. sub('https?://\S+/www\. \S+', ' ', text)#whitespace char with pattern
    text = re. sub('<. *?>+', ' ', text)#special char enclosed in square brackets
    text = re. sub(' [%s]' % re. escape(string. punctuation), ' ', text)#eliminate punctuation from string
    text = re. sub(' \n',' ', text)
    text = re. sub(' \w*\d\w*' ,' ', text)#word character ASCII punctuation
    text = [word for word in text. split(' ') if word not in stopword]  #removing stopwords
    text =" ". join(text)
    text = [stemmer . stem(word) for word in text. split(' ') ]#remove morphological affixes from words
    text = " ". join(text)
    return text
df [ "text"] = df["text"]. apply(clean)


# In[18]:


import matplotlib. pyplot as plt
from wordcloud import WordCloud, STOPWORDS, ImageColorGenerator
text = " ". join(i for i in df. text)
stopwords = set (STOPWORDS)
wordcloud = WordCloud( stopwords=stopwords,background_color="white") . generate(text)
plt. figure(figsize=(10, 10) )
plt. imshow(wordcloud )
plt. axis("off")
plt. show( )


# In[21]:


from sklearn. feature_extraction. text import CountVectorizer
from sklearn. model_selection import train_test_split

x = np.array (df["text"])
y = np.array (df["label"])

cv = CountVectorizer ()
X = cv. fit_transform(x)
print(X)
xtrain, xtest, ytrain, ytest = train_test_split(X, y,test_size=0.33)


# In[22]:


from sklearn.naive_bayes import BernoulliNB
model=BernoulliNB()
model.fit(xtrain,ytrain)


# In[26]:


user=input("Enter the text")
data=cv.transform([user]).toarray()
output=model.predict(data)
print(output)


# In[ ]:




