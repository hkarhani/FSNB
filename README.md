# FSNB – FS Notebook Environment (Docker + JupyterLab)

FSNB provides a ready-to-use, containerized JupyterLab environment tailored for automation, analytics, and network/security tooling.

It is built on top of the official Jupyter Docker Stacks and extended with additional libraries and tools required for FS integrations, scripting, and data workflows.

---

## 🚀 Features

* 🧠 **JupyterLab (modern UI)** instead of classic notebook
* 🐳 Fully containerized via Docker / Docker Compose
* 🔁 Live code sync via bind-mounted volumes
* 📦 Pre-installed Python libraries for automation & analytics
* 🔐 Secure, configurable runtime (token-based access)
* ⚡ Compatible with Docker Hub auto-build pipelines

---

## 📦 Included Capabilities

* Data & analytics: `pandas`, `numpy`, `matplotlib`
* Automation & APIs: `requests`, `paramiko`, `pysnmp`
* Notebook workflows: `papermill`, `nbconvert`, `ipywidgets`
* Dev tooling: `pytest`, `black`
* File handling: `openpyxl`, `Pillow`
* Diagramming: `diagrams`
* Perl support via **IPerl kernel**

---

## 🛠 Requirements

* Docker (>= 20.x)
* Docker Compose (v2 recommended)

---

## ▶️ Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/hkarhani/FSNB.git
cd FSNB
```

---

### 2. Build and run

```bash
docker compose up --build
```

---

### 3. Access JupyterLab

Open your browser:

```
http://localhost:9091/lab
```

---

## 📁 Project Structure

```
FSNB/
├── Dockerfile
├── docker-compose.yaml
├── requirements.txt
└── notebooks/ (your working directory)
```

---

## 🔄 Development Workflow

### Live editing (no rebuild needed)

All local files are mounted into the container:

```yaml
volumes:
  - ./:/notebooks
```

👉 Any change you make locally is instantly available inside JupyterLab.

---

### When to rebuild

Rebuild the container only when:

* `requirements.txt` changes
* system dependencies change
* Dockerfile is updated

```bash
docker compose build --no-cache
docker compose up
```

---

## 🔐 Configuration

You can configure runtime behavior via environment variables.

### Example `.env`

```env
JUPYTER_TOKEN=your_secure_token
JUPYTER_PORT=8888
```

---

## 🧪 Running in Detached Mode

```bash
docker compose up -d
```

Stop:

```bash
docker compose down
```

---

## 🧹 Cleanup

Remove unused images and cache:

```bash
docker system prune -f
```

---

## 📌 Notes

* JupyterLab is used as the default interface
* The container runs as a non-root user (secure by default)
* Base image comes from **Jupyter Docker Stacks (Quay.io)**

---

## ⚠️ Best Practices

* Do NOT blindly update all Python packages in production
* Pin dependencies after stable builds
* Avoid using `latest` tags long-term (pin versions for stability)
* Backup important notebooks before rebuilding

---

## 🔧 Troubleshooting

### Port already in use

Change port in `docker-compose.yaml`:

```yaml
ports:
  - "9092:8888"
```

---

### Container not starting

```bash
docker compose logs -f
```

---

### Permission issues

```bash
chmod -R 755 .
```

---

## 📈 Future Improvements

* Multi-profile setup (dev vs prod)
* GPU-enabled builds
* Automated CI/CD pipeline for image validation
* Pre-configured trading / RL environments

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first.

---

## 📜 License

MIT License

---

## 👤 Author

Hassan El Karhani
https://github.com/hkarhani
