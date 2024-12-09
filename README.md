## Youtube po-token generator

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

## sub 'instaloader' that not work by :robot: issue
- bypassing with network logs get thumbnails
- download images and filtered images 'width == height' / user_profile_image
- apply rest images to OPENAI VISION
- very happy!

## pytubefix
- ?

