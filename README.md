# IP Changer By Just Hacked On

IP Changer by Just Hacked On is a Bash script that automatically changes your public IP address using the Tor network. It’s built for security researchers, privacy-conscious users, and ethical hackers who want to anonymize their traffic while working online.

It works by sending a signal to the Tor service to switch to a new circuit, giving you a new IP each time without restarting your network or Tor service.

![gp]
(https://ibb.co/PGkLXbtC)

## Installation

You can either `git clone` the repository or `curl` the Bash script.

Using `git clone`:

```shell
https://github.com/Just-Hacked-On/IP-Changer.git
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
