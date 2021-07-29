if [ -d eb/.pyenv ]; then 
    echo "EB installation is cached. Apply cache..."
    cp -r eb/.pyenv /root/.pyenv 
    cp -r eb/.ebcli-virtual-env /root/.ebcli-virtual-env
    cp eb/.profile /root/.profile 
    /bin/sh /root/.profile
    eb --version
else
    echo "EB installation is NOT cached"
fi