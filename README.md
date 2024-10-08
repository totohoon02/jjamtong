# Youtube po-token generator

- with selenium
- original repo: https://github.com/JuanBindez/pytubefix
- generate 'visitorData' and 'po-token'
- In my case still considered as 'bot' // use_po_token

### Usage

```
# example.py

regenerate_network_token()
yt = YouTube(url, on_progress_callback = on_progress,
            use_po_token = True,
            token_file = "./token.json"
)
```
