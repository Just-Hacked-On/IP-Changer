# IP Changer By Just Hacked On

IP Changer by Just Hacked On is a Bash script that automatically changes your public IP address using the Tor network. It’s built for security researchers, privacy-conscious users, and ethical hackers who want to anonymize their traffic while working online.

It works by sending a signal to the Tor service to switch to a new circuit, giving you a new IP each time without restarting your network or Tor service.
# 💻 Platform
**Kali Linux**

**Parrot OS**

**Ubuntu / Debian-based systems**

**Arch / Manjaro (with minor modifications)**

![gp]( https://github.com/user-attachments/assets/390c18ab-1119-49d1-9721-afac1728b439 )

## Installation

You can either `git clone` the repository or `curl` the Bash script.

Using :

```shell
git clone https://github.com/Just-Hacked-On/IP-Changer.git
ls
cd IP-Changer
```

Using `curl`:

```shell
curl -O 'https://raw.githubusercontent.com/Just-Hacked-On/IP-Changer/main/IP-Changer.sh'
chmod +x IP-Changer.sh
```

## Usage

Run the script with root privileges:

```shell
sudo bash IP-Changer.sh
```

The script allows you to choose:

How long to stay connected to one Tor exit node (in seconds),

And how many times you want to change your IP (or unlimited times if you choose 0).
