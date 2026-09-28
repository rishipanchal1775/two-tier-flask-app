# Two-Tier Flask + MySQL — Troubleshooting Record

## 1. Makefile `name` command error

**Issue:** `make: name: No such file or directory`

**Solution:** Changed:

```makefile
OS := $(shell name)
```

to:

```makefile
OS := $(shell uname)
```

---

## 2. Docker Compose command not found

**Issue:** `docker-compose` was not installed.

**Solution:** Used modern Docker Compose:

```bash
docker compose
```

and updated the Makefile accordingly.

---

## 3. MySQL UID/GID warning

**Issue:** `${UID}:${GID}` caused warnings and permission problems.

**Solution:** Removed:

```yaml
user: "${UID}:${GID}"
```

from the MySQL service.

---

## 4. MySQL permission denied

**Issue:** MySQL could not write to `/var/lib/mysql`.

**Solution:** Reset the local MySQL data directory:

```bash
docker compose down
sudo rm -rf mysql-data
mkdir -p mysql-data
```

---

## 5. Flask could not find MySQL

**Issue:** `Unknown server host 'mysql'`

**Cause:** MySQL container was not running/ready.

**Solution:** Fixed the MySQL startup and used the Docker service name:

```yaml
MYSQL_HOST: mysql
```

---

## 6. Flask healthcheck failed

**Issue:** `curl: not found`

**Solution:** Removed the Flask `curl` healthcheck because `python:3.9-slim` did not include curl.

---

## 7. Local Flask code was not being built

**Issue:** Compose was using only the remote Docker image.

**Solution:** Added a local build:

```yaml
build:
  context: .
  dockerfile: Dockerfile
```

---

## 8. Docker build failed — no space left

**Issue:** Docker build failed with:

```text
no space left on device
```

**Solution:** Freed disk space on the EC2 instance and rebuilt the image successfully.

---

## 9. Docker Buildx/Bake warning

**Issue:** Warning that Buildx was not installed.

**Solution:** No action required because the Docker image built successfully.

---

## 10. Flask started before MySQL was ready

**Issue:** Flask showed:

```text
Can't connect to server on 'mysql'
```

**Solution:** Added a MySQL healthcheck dependency:

```yaml
depends_on:
  mysql:
    condition: service_healthy
```

---

## 11. Flask container restart loop

**Issue:** Flask repeatedly restarted while MySQL was starting.

**Solution:** Waiting for MySQL health status before starting Flask fixed the restart loop.

---

## 12. MySQL data should not be committed to GitHub

**Issue:** `git add .` failed with permission errors inside `mysql-data/`.

**Solution:** Added:

```gitignore
mysql-data/
```

to `.gitignore`.

---

## 13. Git permission warnings

**Issue:** Git still showed permission warnings while checking `mysql-data/`.

**Solution:** Since `mysql-data/` is ignored, stage only the required project files. Do not use `sudo git add .`.

---

## 14. Final verification

Checked running containers:

```bash
docker compose ps
```

Result:

* Flask: **Up**
* MySQL: **Up (healthy)**
* Port: **5000**

Tested the application:

```bash
curl http://localhost:5000
```

The Flask application returned the expected HTML page.

---

## Final Architecture

```text
Internet
   ↓
EC2 Public IP :5000
   ↓
Docker Port 5000
   ↓
Flask Container
   ↓
Docker Network
   ↓
MySQL Container :3306
```

**Key technologies:** Python, Flask, MySQL, Docker, Docker Compose, AWS EC2, Linux.
