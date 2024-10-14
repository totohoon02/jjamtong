from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import json

class ChromeDriverBuilder:
    def __init__(self) -> None:
        self.chrome_options = Options()
        self.chrome_options.add_argument("--no-sandbox")  # should be first

    def background(self):
        self.chrome_options.add_argument("--headless")
        return self

    def secret_mode(self):
        self.chrome_options.add_argument("--incognito")
        return self

    def disable_dev_shm(self):
        self.chrome_options.add_argument("-disable-dev-shm-usage")
        return self

    def set_performance_log(self):
        self.chrome_options.set_capability(
            'goog:loggingPrefs', {'performance': 'ALL'})
        return self

    def build(self):
        return webdriver.Chrome(options=self.chrome_options)
    

def network_log_filter(on_filter_callbck):
    # decorator function
    def wrapper(driver, *args):
        # get network logs
        perf = driver.get_log("performance")
        log_messages = []

        # filter logs
        for entry in perf:
            log_message = json.loads(entry['message']).get("message", {})
            for arg in args:
                log_message = log_message.get(arg, {})
                if log_message:
                    log_messages.append(log_message)

        return on_filter_callbck(log_messages)
    return wrapper

@network_log_filter
def _get_po_token(log_message):
    visitorId = ""
    poToken = ""

    for postData in log_message:
        if "poToken" not in postData:
            continue

        postData = json.loads(postData)
        visitorId = postData['context']['client']['visitorData']
        poToken = postData['serviceIntegrityDimensions']['poToken']
        break

    write_json("token.json", {
                "visitorData": visitorId, "po_token": poToken})

# call decorator function
driver = ChromeDriverBuilder()\
    .background()\
    .secret_mode()\
    .disable_dev_shm()\
    .set_performance_log()\
    .build()

# get_po_token_from youtube
_get_po_token(driver, *["params", "request", "postData"])


image_urls = []

@network_log_filter
def _get_instagram_thumbnail(thumbnail_urls):
    for thumbnail_url in thumbnail_urls:
        if ".jpg" in thumbnail_url:
            image_urls.append(thumbnail_url)

    write_json("inst_log.json", image_urls)

_get_instagram_thumbnail(driver, *["params", "request", "url"])
