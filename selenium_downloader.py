from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By

import time
import json


def regenerate_network_token():
    sample_video = "https://www.youtube.com/embed/aqz-KE-bpKQ"

    chrome_options = Options()
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument("--headless")
    chrome_options.add_argument('--incognito')
    chrome_options.add_argument('--disable-dev-shm-usage')
    chrome_options.set_capability(
        'goog:loggingPrefs', {'performance': 'ALL'})

    driver = webdriver.Chrome(options=chrome_options)

    driver.get(sample_video)
    driver.delete_all_cookies()
    driver.refresh()
    driver.implicitly_wait(1)

    # press play btn
    elem = driver.find_element(
        By.CLASS_NAME, "ytp-large-play-button-red-bg")
    elem.send_keys(Keys.SPACE)
    time.sleep(1)

    # get network log
    perf = driver.get_log('performance')

    # filter log
    for entry in perf:
        log_message = json.loads(entry['message'])

        postData = log_message.get("message", {}).get(
            "params", {}).get("request", {}).get("postData", {})

        if "poToken" not in postData:
            continue

        postData = json.loads(postData)

        visitorId = postData['context']['client']['visitorData']
        poToken = postData['serviceIntegrityDimensions']['poToken']

    # write as json
    with open("token.json", 'w', encoding='utf-8') as f:
        json.dump({"visitorData": visitorId, "po_token": poToken},
                  f, ensure_ascii=False, indent=4)

    driver.quit()
