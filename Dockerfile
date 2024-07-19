# From the the official hashicorp/tfc-agent image as the base image

FROM hashicorp/tfc-agent:latest

USER root

# Custom images require loading in certificates to communicate with Terraform Enterprise.
# https://support.hashicorp.com/hc/en-us/articles/12983877427603-How-to-Add-Custom-Certificates-to-Terraform-Agents-for-use-with-Terraform-Enterprise

# Install sudo. The container runs as a non-root user, but people may rely on
# the ability to apt-get install things.
RUN apt-get -y install sudo

###############################
### Add custom certificates ###
###############################

ADD ca-certificates.crt /usr/local/share/ca-certificates/cert.crt
RUN chmod 644 /usr/local/share/ca-certificates/cert.crt && update-ca-certificates

# Permit tfc-agent to use sudo apt-get commands.
RUN echo 'tfc-agent ALL=NOPASSWD: /usr/bin/apt-get , /usr/bin/apt' >> /etc/sudoers.d/50-tfc-agent

USER tfc-agent

# this forces trace CLI logs, which show line by line output of Terraform plan/apply/etc
CMD ["-log-level", "trace"]