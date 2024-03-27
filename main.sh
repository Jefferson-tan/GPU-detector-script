#!/bin/bash

# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
# You should have received a copy of the GNU Lesser General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 

# Colour formatting stuff
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script description
echo -e "Simple script to detect ${RED}G${GREEN}P${BLUE}U${NC}s in a system. You need to have lshw installed for it to work."

# This part checks if lshw is installed or not
if command -- lshw >/dev/null 2>&1; then
    echo -e "\n====================\n${GREEN}lshw is installed ✅${NC}\n====================\n"
else
    echo -e $RED"lshw not found, please install lshw before running this script.\n"$NC
    exit 1
fi

# ASCII art of Intel, AMD, and Nvidia compressed with gzip and encoded to base64
intel_logo () {
    printf $BLUE
    base64 -d <<<"H4sIAAAAAAAAA7WWTQ7EIAiF957Co3bRpYtJJukBe5JZ9Ed4DxGaTsOmVHifSsVao8++rWTfpPXYkhLkTItpPZQ/DoFcFAsCxJxYVnYFtVJIA+WUli20b59H+ZMyuZy9MgZCDVWuaZwWTqsHWAkc4WN7qq6weOb5AOkuwntUxWLNyvoxVzMhfjUCElh3qZ5vuB3gGRlDyhT+IbPmkDXxFLnVSsVg6cHJREHfISQzAmKUkQfhAssRXC+Q0qSFaRblbG/zzgvH56XSOYBpWv9ZYFGHxlBuagM4jE2jid/bbEXQ3kxJWG5A7VuvFKKwjDXwSgKtJmgutq5SaBl7wwJvffTQbrZ+PvIckiKze1aTLcK744SV4pe65T4DpgQG0FMLws1Yb94g8ru2DIg0l39zDSl0qR8qJjuK6AsAAA==" | gunzip
    printf $NC
}

amd_logo () {
    printf $RED
    base64 -d <<<"H4sIAAAAAAAAA52UMRLEIAhFe07hUSksUqTYygN6kp1MJi7L/1+TOFSC/AeopYzVW43GtguPxsMi1xHnvW1PzWIC4le+GmHTid4+twHqW3ybc0f6iTTiiyJ+jI4CwUWNg//ve+7AqjaFPitA7F6pdtFSE8QwtRzEx+oYxFALZo4VL2ChPenl4E3IYj6qvIWbsrLhzZEBa3mXKmLT1hFg1gYYn7AdxmpEVJA8x9Xmyw8ghA3k8OW9XEpnEJ1y9gWEyEozAwYAAA==" | gunzip
    printf $NC
}

nvidia_logo () {
    printf $GREEN
    base64 -d <<< "H4sIAAAAAAAAA+WVOw6EMAxEe06Ro7pI6WIlpBwwJ6HBkHjsxEGLtljkCjvMi3+kNHxq+dSyv23bGOLnFLVksSucxUViL1KA+t7oksrPydrzfY0GOboqkZ8QgXqGtIUwrETxdUSJZvt1mALc5JI1Fcrm6Wx/MUSh+DnpieG7PkoTYN1bxGvjAJEGik21SzNpIt25yo2geUI0BPFnDSYIQ+yk9bN0qw8A7Bhro4xmgZt1h3sPUuKozgjsdMnucipB08sudASSQIv2KgtaK+oi8kd/2gNhIHJMdggAAA==" | gunzip
    echo ""
    printf $NC
    base64 -d <<< "H4sIAAAAAAAAA6XTzwqAIAwH4HtPsUcVkujQoZMQBr2bT1IWxbbf0v7ELuqaH1OJ9i+FvhhdCm3OmtncRHT+vLDpuI3Ha1wv7bdQArNu3rEh4MYUHIteAk2x9hbAR7qTU0hlFSPb0vIO0G8ymYCsKMVy3sZIWFi5h8xR1AAnKv8ypfKjU0MNZvXQffHQ4W7exQu0Uivvy2eVnwNcNN1caPAKoOLBqQ8EAAA=" | gunzip
}

# Lists out GPU in a system, ignores errors about the command running in non-sudo mode, then filters out the vendors
listGPU=$( (lshw -C video) 2>/dev/null | awk '$1=="vendor:"{$1=""; print}')

# Counts the amount of GPUs detected based on their physical IDs
countGPU=$( (lshw -C video) 2>/dev/null | awk '$1=="physical"{print $3}')

echo -e "🭽▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔🭾\n▏Detected GPU(s): ${countGPU+1}▕\n🭼▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁🭿\n"

# Function for detecting intel GPU to avoid duplicated codes
detect_intel () {
    echo -e "${BLUE}Intel${NC} GPU detected"
    intel_logo
}

# Logic for checking which GPU exists in system
if (grep NVIDIA <<< $listGPU) 1>/dev/null ; then
    echo -e "${GREEN}NVIDIA${NC} GPU detected"
    nvidia_logo
elif (grep Intel <<< $listGPU) 1>/dev/null ; then
    detect_intel
fi

if (grep AMD <<< $listGPU) 1>/dev/null ; then
    echo -e "${RED}AMD${NC} GPU detected"
    amd_logo
elif (grep Intel <<< $listGPU) 1>/dev/null ; then
    detect_intel
else
    echo Unknown or no GPU detected
fi
