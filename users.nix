{ config, lib, pkgs, ... }:

{
  users.users.jyri-matti = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "docker" "wheel" "nginx" ];
    hashedPasswordFile = "/home/jyri-matti/pwd";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDH+RopBjRi4zP4nJ7JbEUXomE0wq50MFYGb5EEwJ6LCT+DZK4QM+Qp97GWB3M1EsZ9rgskSyEf5cWYjXKUZq/70IzYvMM7VICwOnI5pu/6wKNfp+RFu7E7bh5RIdgMAvv7SUUn9ZhEumx+MtvczxSCu7JzYDQ8xpGdlKcfvscxid8XmpvNdntc1HqeTuJfg8axk2vNfK76h7XpWf6/PNKqJFAvcOsv+tRDFeTplxkQYJcaoqgIoDnnM/elW97xRFartPk5LlR2aed0H0QYBalcPDncboquOdzgAFq5oxNO1m9uZT7iG+nBopyr59+EReg4Nb/VVsMnbSd0Q5v/4gS8d9XrJ1hV+/pPkHOlcAwTUh5IQpJoMDauo7Az7Q5fAoozasePN4RcsfxHxVjxty63SaCawHyl1n28Vx6bf/5n7XJRrG6G7iSiisPp9Y8CYFXmkJUUOfxPh/NHa+8wcyrQ18L85SRQsnUAbdQxdFT4obssR6XkZ497WH48/Yfmw/r9EYYleaIhDp90atOnqWVSouhl/dwr2lwTbhzuz2JPWQLImVzEqkhBh8KOeG+2egLjseFSvAmlo2X8WD1rr8L2m3rBYnOSKwG7nNJhYUCsXA5q5HXdJC0EX5c450bD7A7X2+BbzsKlTV+QqFonQHoVbuGuZ3lt8MhyVUgsXUuzIQ== jyri-matti.lahteenmaki@solita.fi"
      "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA0i431fPGrXnualHWXzQokwzBOKXM/H95Ecfbo3G1169AynCZR5UAY7GUlQO9bpqBxniN1/Xnr7EFArHgcxTNFoByNQ2f384yGVbLDVbB9m78r1c2mjB+/eLZTEb+mW3IEDnH8jDLdrDPvqIHYHa25S1EqA7Hk05CZLr31Ecez3pQ8/hRvsQNZeFzFSPfsbK2+l4WfDaYPmmUtgSe9BVTqAcAbjLJHmete2gmB69nBVS3ydYDJESlrpzYoAtdN260Pu2bhuAjqvjrvWSDLgntN+R6ZpOms8PjwLboCBg9TIfD3S2GUxYENfGXDapnEiZsUIhk9aqv0163P2Aht/agzQ== jyri-matti@lahteenmaki.net"
      "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAgBW/BAad494wzcxFKmZhuuUvB5G1I6Xl0jkp1UPpYLU3Zj2J2WMarJzuEWX5VRXUw/PnMm+PPPMFhEELdD68SjVHnWugQCLvuMaRfrMmwhU4xiHLmM7s513Bi/Ps3ja85guDYQFTjlb8KZz97Zjct1QJr9/OVImk+xrS9kiDiZvrbxOxmgcIkTFysd0XUpya85D/iCBuB6urFYPSWLQ1Eam6vtS6K01VmFBB5bab6nrIAaH+RRMdd9CYbQ9XVB2/u24PP4OGG4tYVAwwI0rbowHj1pkxueqLxMsegwBPZ9x0ZF3PtwUmgSkFx8V7Qy7uXhQbnwIFWVnTtqRkv78Qwcf0HCNCbpoMpIwpUg/Pj+EZ7RmeojIk6gFPgfdzylkI7QAXZtBW4p5qoLG/grbDVArPrKZCpLbBReJttvCPNW7oVhgEx/CqBO23TCv1aNtGkuWW0mNgwFc3sjr70mRvPvMGPhn+kfsmE+S18begWuWyfp3wxc2gECpmBNk676M8D8HtEQz/90d2Vi/z4evtyipS+TVs23VigpmYGL4nCNPMiFnsw+DO9Om7a0G3RhuzuoLwKmsU4N0VbVHZwmqENWZlDx3blEKFfSmuQgAmgOLrscFl8SFCSSno5yfAQiVUYuMaRSv+ZlzIwM/UWZ1QnzwbAlF5eI8cp2RaIagjaEs/w== iphone-rsa-key-20160805"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC76Eykcgw9hmJu2WEewm8pXJoqFq8ADF21LPXmSQ11T2SwN1SZJBxjbNbvfAG8eq4d2Oo5ht4rDXT5h9jHT7ddmoe/BymyxdfnS4wLGei1oG1IXi4DWtWDYTwNVi2EQRUzjr4iJb1OAHukV2Zi62qvjUyWrpMIaaH+gbcQUWPFQBbM7MO9ou0WzbwZoT/qg2mh1OoAXg90fYWsdQQqSlwygLrehJNwzwq7vDhODxjcatGA+9WwXxUIshC9jmHDyk9nrOET0Q3k7PLIHrJ+sybI1onqQxL9bB9kJ+JO8JA+wk4suyYje8K8Tv0OJzZOzybEzYEspKORdpyV63nxIdCW2/U+TxYXbWrP4V6PAZ6qGeiTQF66BJY9mw3ywPIw1XXGq6Id3nRKoWpvKMNWhHSiKAUosad92vk+zroviBQV3mV9KblapzNUTiBueGiRcX5jyxmhMPc5Zwm4TNtBDsRZan6zAcJDTfK7S6Me91EkS5Fd0hAqNPtbrcmek2WMLkS3rZ51/hEslGAU8nsCRyocAWm7Iov1Tfi+ZX+E1ul81VREL0NOoO7+fScgnxcQZPgzQYzewFmzbrqvCXbJM9b48YpM6Jo1lpK/6ScHGJgzeNhK2xjkaF/JIwt1lKjM7SmsIO0C82v/Hb8zSVvL1PS0ZVYVUZxCEiSDTSYtdxFybQ== pi@raspberrypi"
    ];
  };

  users.users.joona = {
    isNormalUser = true;
    uid = 1001;
  };

  users.users.juuso = {
    isNormalUser = true;
    uid = 1002;
  };

}
