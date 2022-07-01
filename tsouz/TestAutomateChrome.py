from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager

url = "https://google.com/"
text = "Hello world"

driver = webdriver.Chrome(ChromeDriverManager().install())
driver.maximize_window()
driver.get(url)

# WebDriverWait(driver, 5).until(
#     EC.presence_of_element_located((By.ID, "text_to_score"))
# )  # Wait until the `text_to_score` element appear (up to 5 seconds)
# driver.find_element_by_id("text_to_score").clear()
# driver.find_element_by_id('text_to_score').send_keys(text)
driver.quit()