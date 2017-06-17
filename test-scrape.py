import dryscrape
from bs4 import BeautifulSoup
sess = dryscrape.Session()
sess.visit("https://airbnb.com/rooms/16189604")
response = sess.body()
soup = BeautifulSoup(response)
print(response)
