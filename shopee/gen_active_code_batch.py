import requests
import os

# 禁用代理设置
os.environ['HTTP_PROXY'] = ''
os.environ['HTTPS_PROXY'] = ''

def get_active_code():
    url = "http://42.192.40.156:18080/v1/shopee/active_code"
    json_data = {
        "expired_at": "2025-02-05 12:00:00"
    }
    resp = requests.post(url=url, json=json_data)
    return resp.json().get("data")

if __name__ == "__main__":
    file = "./active_code.txt"
    with open(file, "+a") as f:
        for i in range(2000):
            active_code = get_active_code()
            f.write(active_code)
            f.write("\n")
