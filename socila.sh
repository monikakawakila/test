#!/bin/bash
echo "STARTING WEB HUMAN BROWSING V 1.1.1"

# List of URLs to request (Including YouTube URLs)
urls=(
    "https://www.aljazeera.net/"
    "https://www.lebanonfiles.com/"
    "https://x.com/"
    "https://www.al-akhbar.com/"
    "https://youtube.com/"
    "https://ar.aliexpress.com/?gatewayAdapt=glo2ara"
    "https://www.instagram.com/"
)

# List of YouTube Video IDs (just an example, add more as needed)
youtube_video_ids=(
    "EzNry5vr5z8"
    "oJUvTVdTMyY"
    "9Ij4kdVXSAE"
    "bNyUyrR0PHo"
    "H5dgaV2nK3U"
)

# List of common User-Agents to simulate different browsers/devices
user_agents=(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.82 Safari/537.36 Edge/93.0.961.52"
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36"
    "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:40.0) Gecko/20100101 Firefox/40.0"
    "Mozilla/5.0 (Linux; Android 10; Pixel 4 XL) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Mobile Safari/537.36"
    "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/537.36 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/537.36"
)

# List of common Accept-Language headers (different regions)
accept_languages=(
    "en-US,en;q=0.9"
    "en-GB,en;q=0.9"
    "es-ES,es;q=0.9,en;q=0.8"
    "fr-FR,fr;q=0.9,en;q=0.8"
    "ar-SA,ar;q=0.9,en;q=0.8"
)

# List of common Accept-Encoding headers
accept_encoding=(
    "gzip, deflate, br"
    "gzip, deflate"
    "br"
    "identity"
)

# List of Referrers (mimic browsing through search engines or other pages)
referers=(
    "https://google.com"
    "https://bing.com"
    "https://duckduckgo.com"
    "https://yahoo.com"
    "https://www.facebook.com"
    "https://www.twitter.com"
)

# Function to simulate scrolling behavior
simulate_scrolling() {
    total_scroll_time=$((RANDOM % 10 + 5))  # Random total scroll time between 5-15 seconds
    scroll_step_time=$((RANDOM % 3 + 2))    # Random pause during scrolling, between 2-5 seconds
    echo "Starting to scroll for $total_scroll_time seconds..."

    while (( total_scroll_time > 0 )); do
        scroll_duration=$((RANDOM % 2 + 1))  # Simulate scroll duration between 1-2 seconds
        echo "Scrolling for $scroll_duration seconds..."
        sleep $scroll_duration
        total_scroll_time=$((total_scroll_time - scroll_duration))

        if (( total_scroll_time > 0 )); then
            echo "Pausing for $scroll_step_time seconds..."
            sleep $scroll_step_time
        fi
    done
}

# Function to simulate random clicks on the page
simulate_clicks() {
    click_probability=$((RANDOM % 5))
    if [ $click_probability -eq 0 ]; then
        # Simulate a click on a random link or button
        echo "Simulating a click on a page element..."
        sleep $((RANDOM % 3 + 1))  # Random time to simulate the act of clicking
    fi
}

# Function to simulate human-like sleep pattern (simulate night time)
simulate_sleep() {
    current_hour=$(date +%H)  # Get the hour in 24-hour format (00-23)
    echo "-------------------------------------------------------"
    echo "Current hour: $current_hour"

    if [ "$current_hour" -ge 22 ] || [ "$current_hour" -lt 6 ]; then
        sleep_duration=$((RANDOM % 3 + 6))  # Random sleep time between 6 and 8 hours
        echo "It's night time. Simulating sleep for $sleep_duration hours..."
        sleep "$((sleep_duration * 3600))"  # Convert hours to seconds
    fi
}

# Function to make a request with randomized parameters and simulate crawling
make_request() {
    # Select a random URL from the list
    url=${urls[$RANDOM % ${#urls[@]}]}
    
    # If the URL is a YouTube URL, choose a random video ID from the list
    if [[ "$url" == "https://youtube.com/" ]]; then
        youtube_video_id=${youtube_video_ids[$RANDOM % ${#youtube_video_ids[@]}]}
        url="https://www.youtube.com/watch?v=$youtube_video_id"
    fi

    # Select a random User-Agent from the list
    user_agent=${user_agents[$RANDOM % ${#user_agents[@]}]}
    
    # Select a random Accept-Language header from the list
    accept_language=${accept_languages[$RANDOM % ${#accept_languages[@]}]}
    
    # Select a random Accept-Encoding header
    encoding=${accept_encoding[$RANDOM % ${#accept_encoding[@]}]}
    
    # Randomly include a Referer header (common in real browsing)
    referer=${referers[$RANDOM % ${#referers[@]}]}

    # Initialize an empty Cookie header
    cookie_header=""

    # Add specific cookies for Instagram if the URL is Instagram
    if [[ "$url" == "https://www.instagram.com/" ]]; then
        cookie_header="Cookie: sessionid=your_session_id_here; csrftoken=your_csrf_token_here"
    fi

    # Add specific cookies for X.com if the URL is X.com
    if [[ "$url" == "https://x.com/home" ]]; then
        cookie_header="Cookie: auth_token=your_auth_token_here; guest_id=your_guest_id_here"
    fi

    # Make the initial page request using curl with the random headers
    echo "[*][*][*] Requesting URL: $url"
    response=$(curl --ssl-no-revoke -s -w "%{http_code}" -o /dev/null -A "$user_agent" \
         -H "Accept-Encoding: $encoding" \
         -H "Accept-Language: $accept_language" \
         -H "Referer: $referer" \
         -H "$cookie_header" \
         "$url")
    
    if [ "$response" -eq 200 ]; then
        echo "Request successful"
    else
        echo "Error encountered (HTTP Code: $response). Retrying..."
        sleep 5  # Wait before retrying
    fi

    # Simulate scrolling on the page (mimic user browsing)
    simulate_scrolling
    
    # Simulate random clicks on the page
    simulate_clicks
}

# Loop indefinitely to make requests with crawling behavior
while true; do
    # Simulate sleep during night hours (10 PM - 6 AM)
    simulate_sleep

    # Randomly decide whether to simulate crawling or simulate idle time
    if [ $((RANDOM % 5)) -eq 0 ]; then
        idle_time=$((RANDOM % 15 + 5))  # Random idle time between 5 and 20 seconds
        echo "Idle time: $idle_time seconds..."
        sleep $idle_time
    else
        make_request
        delay=$((RANDOM % 11 + 5))  # Random delay between 5 and 15 seconds
        sleep $delay
    fi
done
