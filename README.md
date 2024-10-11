# Youtube po-token generator

- with selenium
- original repo: https://github.com/JuanBindez/pytubefix
- generate 'visitorData' and 'po-token'
- In my case still considered as 'bot' // use_po_token

### Usage

```python
# example.py

regenerate_network_token()
yt = YouTube(url, on_progress_callback = on_progress,
            use_po_token = True,
            token_file = "./token.json"
)

# token verifier
yt = YouTube(url, on_progress_callback=on_progress,
            use_po_token=True, po_token_verifier=token_verifier)
```
