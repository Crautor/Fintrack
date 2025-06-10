FROM instrumentisto/flutter:3.32.0

WORKDIR /app

COPY . .

RUN apt update && apt install -y \
    libxss1 \
    libindicator7 \
    wget \
    && wget -P /tmp https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt install -y /tmp/google-chrome-stable_current_amd64.deb \
    && rm /tmp/google-chrome-stable_current_amd64.deb

RUN rm -rf .dart_tool

RUN flutter pub get

RUN flutter config --enable-web

EXPOSE 8000

CMD ["flutter", "run", "-d", "web-server", "--web-port=8000", "--web-hostname=0.0.0.0"]
