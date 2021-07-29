if [ -d eb/.pyenv ]; then 
    echo "EB installation is cached. Apply cache..."
    cp eb/.pyenv /root/.pyenv 
    cp eb/.ebcli-virtual-env /root/.ebcli-virtual-env
    cp eb/.profile /root/.profile 
    source /root/.profile
    eb --version
else
    echo "EB installation is NOT cached"
fi