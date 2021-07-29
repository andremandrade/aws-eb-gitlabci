if ! command -v eb > /dev/null 
then
    echo "EB CLI not found. Starting installation..."
    apt-get update
    apt-get install -y build-essential zlib1g-dev libssl-dev libncurses-dev libffi-dev libsqlite3-dev libreadline-dev libbz2-dev

    git clone https://github.com/aws/aws-elastic-beanstalk-cli-setup.git
    ./aws-elastic-beanstalk-cli-setup/scripts/bundled_installer
    echo 'export PATH=/root/.pyenv/versions/3.7.2/bin:$PATH' >> /root/.profile
    echo 'export PATH="/root/.ebcli-virtual-env/executables:$PATH"' >> ~/.profile
    echo "Test EB CLI installation:"
    eb --version
    exit
fi

echo "EB CLI is already installed!"