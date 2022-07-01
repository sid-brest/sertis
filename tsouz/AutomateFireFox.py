from selenium import webdriver
from webdriver_manager.firefox import GeckoDriverManager
 
driver = webdriver.Firefox(executable_path=GeckoDriverManager().install())
 
driver.maximize_window()
driver.get("https://google.com")
print('driver Title:',driver.title)
print('Driver name:',driver.name)
print('Driver URL:',driver.current_url)
driver.quit()