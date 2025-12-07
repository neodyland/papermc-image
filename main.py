import requests
from bs4 import BeautifulSoup


class NotFoundError(Exception):
    pass


def main():
    response = requests.get("https://papermc.io/downloads/paper")
    soup = BeautifulSoup(response.text, 'html.parser')
    link = soup.find("a", href=lambda href: href and href.endswith(".jar"))
    if link is None:
        raise NotFoundError("Could not find the download link for the latest PaperMC jar file.")
    with open("latest.txt", "w") as f:
        f.write(link.get('href'))


if __name__ == "__main__":
    main()
