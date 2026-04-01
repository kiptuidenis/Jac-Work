import requests
import sseclient
import json

def test():
    print("Connecting to /sse...")
    response = requests.get('http://127.0.0.1:3001/sse', stream=True, timeout=5)
    client = sseclient.SSEClient(response)
    post_url = None
    for event in client.events():
        print(f"Got Event: {event.event}")
        print(f"Got Data: {event.data}")
        if event.event == "endpoint":
            post_url = event.data
            break
    
    print(f"POST URL is: {post_url}")
    
    msg = {
        "jsonrpc": "2.0",
        "method": "tools/list",
        "id": 1,
        "params": {}
    }
    
    # Send post
    if post_url.startswith("http"):
        full_url = post_url
    else:
        full_url = f"http://127.0.0.1:3001{post_url}"
        
    print(f"POSTing to: {full_url}")
    r = requests.post(full_url, json=msg)
    print("POST Response:", r.status_code, r.text)
    
    # Wait for result on SSE
    for event in client.events():
        print(f"Follow up Event: {event.event}")
        if event.event == "message":
            print(f"Message Data: {event.data}")
            break

if __name__ == "__main__":
    test()
