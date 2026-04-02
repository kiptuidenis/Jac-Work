import time;
import from bs4 { BeautifulSoup }
import from playwright.sync_api { sync_playwright }

def scrape_dynamic(url: str) -> str {
    html = "";
    with sync_playwright() as p {
        browser = p.chromium.launch(headless=True);
        page = browser.new_page();
        page.goto(url, wait_until="domcontentloaded");
        
        # Scroll down smoothly to trigger any lazy loading
        last_height = page.evaluate("document.body.scrollHeight");
        while True {
            page.evaluate("window.scrollTo(0, document.body.scrollHeight)");
            time.sleep(1);
            new_height = page.evaluate("document.body.scrollHeight");
            if new_height == last_height {
                break;
            }
            last_height = new_height;
        }
        
        html = page.content();
        browser.close();
    }
    
    # Parse with BS4 to clean up non-content
    soup = BeautifulSoup(html, "html.parser");
    for tag in soup(["script", "style", "nav", "footer"]) {
        tag.decompose();
    }
    
    # Extract only the readable text
    text = soup.get_text(separator='\n', strip=True);
    return text;
}

with entry {
    url = "https://docs.jaseci.org/reference/language/foundation/";
    print(f"Scraping {url} with Playwright scrolling strategy...");
    content = scrape_dynamic(url);
    print("\n--- Extracted Content Preview ---\n");
    print(content[:500]);
    print("\n...\n");
    print(f"Total extracted length: {len(content)} chars");
    
    with open("foundation_content.txt", "w", encoding="utf-8") as f {
        f.write(content);
    }
    print("Content successfully saved to foundation_content.txt");
}
