# EduSec Docker Setup Guide

This guide will help you run EduSec College Management System using Docker containers.

## Prerequisites

- **Docker Desktop** installed on your system
  - Download from: https://www.docker.com/products/docker-desktop
  - Ensure Docker is running before proceeding

## Quick Start

### 1. Build and Start Containers

Open a terminal in the EduSec directory and run:

```bash
docker-compose up -d
```

This command will:
- Build the PHP/Apache container
- Download the MySQL container
- Start both services in the background
- Create persistent volumes for data storage

### 2. Wait for Services to Initialize

Check if containers are running:

```bash
docker-compose ps
```

You should see both `edusec_web` and `edusec_db` with status "Up".

### 3. Access the Application

Open your browser and navigate to:

```
http://localhost:8080
```

You should see the EduSec requirements checker page.

### 4. Complete Installation

1. **Requirements Check**: Verify all requirements are satisfied (should show green checkmarks)
2. **Click Install**: Proceed to the installation wizard
3. **Database Configuration**: 
   - Database Host: `db`
   - Database Name: `edusec`
   - Username: `edusec_user`
   - Password: `edusec_pass`
4. **Admin Account**: Create your administrator credentials
5. **Institute Setup**: Configure your institution details
6. **Complete**: Login with your admin credentials

## Container Management

### View Logs

```bash
# View all logs
docker-compose logs

# View web server logs
docker-compose logs web

# View database logs
docker-compose logs db

# Follow logs in real-time
docker-compose logs -f
```

### Stop Containers

```bash
docker-compose stop
```

### Start Containers (after stopping)

```bash
docker-compose start
```

### Restart Containers

```bash
docker-compose restart
```

### Stop and Remove Containers

```bash
docker-compose down
```

**Note**: This preserves your data in Docker volumes.

### Stop and Remove Everything (including data)

```bash
docker-compose down -v
```

**Warning**: This will delete all database data!

## Accessing Container Shell

### Access Web Container

```bash
docker-compose exec web bash
```

### Access Database Container

```bash
docker-compose exec db bash
```

### Run MySQL Commands

```bash
docker-compose exec db mysql -u edusec_user -pedusec_pass edusec
```

## Troubleshooting

### Port Already in Use

If port 8080 or 3306 is already in use, edit `docker-compose.yml`:

```yaml
services:
  web:
    ports:
      - "8081:80"  # Change 8080 to another port
  db:
    ports:
      - "3307:3306"  # Change 3306 to another port
```

### Permission Errors

If you encounter permission errors:

```bash
docker-compose exec web chown -R www-data:www-data /var/www/html
docker-compose exec web chmod -R 777 /var/www/html/runtime /var/www/html/web/assets
```

### Database Connection Failed

Ensure the database container is fully initialized:

```bash
docker-compose logs db | grep "ready for connections"
```

Wait until you see this message, then try accessing the application again.

### Composer Dependencies Failed

If Composer installation fails during build, install manually:

```bash
docker-compose exec web composer install
```

### Clear Application Cache

```bash
docker-compose exec web rm -rf runtime/cache/*
```

### Rebuild Containers

If you make changes to Dockerfile or need a fresh start:

```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## Configuration

### Environment Variables

Edit `.env` file to customize:
- Database credentials
- Port mappings
- PHP timezone

After changing `.env`, restart containers:

```bash
docker-compose down
docker-compose up -d
```

### Database Backup

```bash
docker-compose exec db mysqldump -u edusec_user -pedusec_pass edusec > backup.sql
```

### Database Restore

```bash
docker-compose exec -T db mysql -u edusec_user -pedusec_pass edusec < backup.sql
```

## Development Workflow

1. **Code Changes**: Edit files in your local directory
2. **Auto-Reload**: Changes are reflected immediately (volume mounted)
3. **Clear Cache**: If needed, clear runtime cache
4. **View Logs**: Monitor application logs for errors

## Production Considerations

This Docker setup is designed for **development purposes**. For production:

1. Use environment-specific `.env` files
2. Set strong passwords
3. Configure SSL/TLS certificates
4. Use Docker secrets for sensitive data
5. Implement proper backup strategies
6. Configure resource limits
7. Use production-grade web server (Nginx + PHP-FPM)

## Additional Resources

- EduSec Documentation: http://www.electrogenicsech.com/forum
- Docker Documentation: https://docs.docker.com
- Yii2 Framework: https://www.yiiframework.com

## Support

For issues related to:
- **Docker Setup**: Check this guide's troubleshooting section
- **EduSec Application**: Visit http://www.electrogenicsech.com/forum
- **Docker**: Visit https://docs.docker.com
