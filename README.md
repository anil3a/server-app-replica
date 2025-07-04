# 🚧 PHP Multi-VHost Docker with Dynamic Environment Support

This project allows you to run **multiple virtual hosts (sites)** using a single Docker image based on Apache + PHP, where **site configurations (domains, folders, and ports)** are passed at runtime via environment variables.

It uses:

* Apache + PHP
* One `vhost-site.conf.template` file
* A dynamic `entrypoint.sh` script that:

  * Creates Apache virtual host config files on-the-fly
  * Adds required `Listen` ports
  * Enables the generated vhosts

---

## 📆 Folder Structure

```
.
├── Dockerfile
├── entrypoint.sh
├── vhost-site.conf.template
├── docker-compose.yml
└── html/
    ├── n8n-logger/apache_log_watcher.py
    ├── site1/
    ├── site2/
    └── site3/
```

---

## 💪 Building the Docker Image

You can build the Docker image locally using:

```bash
docker build -f builds/Dockerfile.build -t server-app-replica .
```

> You can also push this to a registry like DockerHub or GitLab Container Registry if you want to use it in Portainer or other servers.

---

## 👋 Running via `docker-compose.yml`

To host multiple sites from a single image, define them in the `SITES` environment variable using this format:

```
folder:domain:port folder:domain:port ...
```

### ✅ Example: `docker-compose.yml`

```yaml
services:
  php-multisite:
    image: server-app-replica:latest
    ports:
      - "8001:8001"
      - "8002:8002"
      - "8003:8003"
    volumes:
      - ./html:/var/www/html
    environment:
      SITES: "site1:site1.local:8001 site2:site2.local:8002 site3:site3.local:8003"
```

Start with:

```bash
docker-compose up -d
```

Now you can access your sites via:

* [http://localhost:8001](http://localhost:8001) → `/html/site1`
* [http://localhost:8002](http://localhost:8002) → `/html/site2`
* [http://localhost:8003](http://localhost:8003) → `/html/site3`

Update your `/etc/hosts` if needed:

```txt
127.0.0.1 site1.local site2.local site3.local
```

---

## ⚙️ Using in Portainer Stack

To use this image in **Portainer**:

1. Push your image to a registry (e.g. GitLab or DockerHub)
2. Go to **Stacks** → **Add Stack**
3. Paste your `docker-compose.yml` (use the registry image name)
4. Adjust the `SITES` env variable as needed
5. Deploy the stack

> You can reuse this image across environments by changing only the `SITES` variable and ports.

---

## 📉 Environment Variable Format

| Value  | Description                         |
| ------ | ----------------------------------- |
| folder | Folder name inside `/var/www/html/` |
| domain | ServerName used in Apache           |
| port   | Apache `Listen` and container port  |

Each site will get its own:

* Apache VirtualHost on the given port
* Error and access logs
* Document root: `/var/www/html/<folder>`

---

## ✅ Example Site Template (`vhost-site.conf.template`)

```apache
<VirtualHost *:${PORT}>
    ServerName ${DOMAIN}
    DocumentRoot /var/www/html/${FOLDER}

    <Directory /var/www/html/${FOLDER}>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/${FOLDER}-error.log
    CustomLog \${APACHE_LOG_DIR}/${FOLDER}-access.log combined
</VirtualHost>
```

---
## Contributing
Contributions are welcome! If you have suggestions or improvements, feel free to open an issue or submit a pull request.

--
## Contributors
- [@anil3a](https://github.com/anil3a)


---

## 📜 License

MIT License.
