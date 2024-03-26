#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

intel_logo () {
    printf $BLUE
    base64 -d <<<"H4sIAAAAAAAAA7WWTQ7EIAiF957Co3bRpYtJJukBe5JZ9Ed4DxGaTsOmVHifSsVao8++rWTfpPXYkhLkTItpPZQ/DoFcFAsCxJxYVnYFtVJIA+WUli20b59H+ZMyuZy9MgZCDVWuaZwWTqsHWAkc4WN7qq6weOb5AOkuwntUxWLNyvoxVzMhfjUCElh3qZ5vuB3gGRlDyhT+IbPmkDXxFLnVSsVg6cHJREHfISQzAmKUkQfhAssRXC+Q0qSFaRblbG/zzgvH56XSOYBpWv9ZYFGHxlBuagM4jE2jid/bbEXQ3kxJWG5A7VuvFKKwjDXwSgKtJmgutq5SaBl7wwJvffTQbrZ+PvIckiKze1aTLcK744SV4pe65T4DpgQG0FMLws1Yb94g8ru2DIg0l39zDSl0qR8qJjuK6AsAAA==" | gunzip
    printf $NC
}

amd_logo () {
    printf $RED
    base64 -d <<<"H4sIAAAAAAAAA52UOxLDMAhEe06ho1JQpHCRygf0SexJxjKCXZRIQ2PA8PhIrfVz7OYF6rF3/pnFuvz02F//ivgA2W7d9ma2D4fXb9idia0WICV5YMQ8CJ8V8TBqUnsTFAw+6jV8W4k+E1IA0d5d2EhLhRBHjaEMqAQN46a4LerGgU2A03T95QG7khluTE0bWnTYUpA8nQI70U13ymj7foKGHalv1hhxwBG6ZmBfVrG56OxR8G49jXsIFw/L04m+6eQEYFU73RkGAAA=" | gunzip
    printf $NC
}

nvidia_logo () {
    printf $GREEN
    base64 -d <<< "H4sIAAAAAAAAA+WVOw6EMAxEe06Ro7pI6WIlpBwwJ6HBkHjsxEGLtljkCjvMi3+kNHxq+dSyv23bGOLnFLVksSucxUViL1KA+t7oksrPydrzfY0GOboqkZ8QgXqGtIUwrETxdUSJZvt1mALc5JI1Fcrm6Wx/MUSh+DnpieG7PkoTYN1bxGvjAJEGik21SzNpIt25yo2geUI0BPFnDSYIQ+yk9bN0qw8A7Bhro4xmgZt1h3sPUuKozgjsdMnucipB08sudASSQIv2KgtaK+oi8kd/2gNhIHJMdggAAA==" | gunzip
    echo ""
    printf $NC
    base64 -d <<< "H4sIAAAAAAAAA6WSMQ6AMAhFd0/BUTswdGBw8oCexKSNsf8XpEbzFwt8Xiki7TuPmkk5S3vhPhwZ/HM0sgXfmEc38YIFVaE9+nI0RrWWndgRyFPvgJrwtJyW1CDOnsz66Pm2CuXlKx/UULvymw/x8PKrgNHeWjZsHVQRLF6Sdy0zO9Dpcswq9xsE7CaT6XYBL4SiI+0DAAA=" | gunzip
}

echo "Simple script to detect GPUs in a system. You need to have lshw installed for it to work."

if command -- lshw >/dev/null 2>&1; then
    echo -e $GREEN"lshw is installed\n"$NC
else
    echo -e $RED"lshw not found, please install lshw before running this script.\n"$NC
    exit 1
fi

listGPU=$( (lshw -C video) 2>/dev/null | awk '$1=="vendor:"{$1=""; print}')

#( lshw -C video ) 2>/dev/null | awk '$1=="vendor:"{$1=""; print $0}'

if (grep NVIDIA <<< $listGPU) 1>/dev/null ; then
    echo NVIDIA GPU detected
    nvidia_logo
elif (grep Intel <<< $listGPU) 1>/dev/null ; then
    echo Intel GPU detected
    intel_logo
else
    echo Unknown GPU
fi

if (grep AMD <<< $listGPU) 1>/dev/null ; then
    echo AMD GPU detected
    amd_logo
elif (grep Intel <<< $listGPU) 1>/dev/null ; then
    echo Intel GPU detected
    intel_logo
else
    echo Unknown GPU
fi
