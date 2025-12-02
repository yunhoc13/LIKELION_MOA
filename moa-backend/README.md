# MOA Backend Server

Backend API for MOA (Meet On App) - A student activity matching platform

## Setup Instructions

### Prerequisites
- Node.js and npm installed
- Docker and Docker Compose installed

### Step 1: Install Dependencies

```bash
cd moa-backend
npm install
```

### Step 2: Start PostgreSQL Database

```bash
docker-compose up -d
```

This will:
- Start a PostgreSQL 15 container
- Create the `moa_db` database
- Create the `users` table automatically
- Expose PostgreSQL on `localhost:5432`

Verify the database is running:
```bash
docker-compose ps
```

### Step 3: Start the Backend Server

```bash
npm start
```

The server will start on `http://localhost:3000`

You should see:
```
MOA Backend server is running on port 3000
Health check: http://localhost:3000/health
Database connected successfully at [timestamp]
```

## Testing the API

### Health Check

```bash
curl http://localhost:3000/health
```

### Sign Up

```bash
curl -X POST http://localhost:3000/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "name": "John Doe",
    "university": "Boston University"
  }'
```

Response (success):
```json
{
  "message": "Signup successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "test@example.com",
    "name": "John Doe",
    "university": "Boston University"
  }
}
```

### Login

```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

Response (success):
```json
{
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "test@example.com",
    "name": "John Doe",
    "university": "Boston University",
    "major": null,
    "graduation_year": null,
    "bio": null
  }
}
```

## Database Management

### Stop Database

```bash
docker-compose down
```

This stops the container but preserves data.

### Delete Database (Reset Everything)

```bash
docker-compose down -v
```

This removes the container and all data volumes.

### View Database Logs

```bash
docker-compose logs postgres
```

### Connect to Database Directly

```bash
docker exec -it moa_postgres_db psql -U moa_user -d moa_db
```

Then you can run SQL queries like:
```sql
SELECT * FROM users;
```

## Environment Variables

Copy `.env.example` to `.env` and modify as needed:

```
PORT=3000                          # Server port
NODE_ENV=development               # Environment
DB_HOST=localhost                  # Database host
DB_PORT=5432                       # Database port
DB_NAME=moa_db                     # Database name
DB_USER=moa_user                   # Database user
DB_PASSWORD=moa_password           # Database password
JWT_SECRET=your_secret_key         # JWT signing key
JWT_EXPIRY=7d                      # Token expiration time
CORS_ORIGIN=http://localhost:3000  # Allowed CORS origins
```

## API Endpoints

### Authentication

- **POST** `/api/auth/signup` - Create a new user account
- **POST** `/api/auth/login` - Login and get JWT token

## Next Steps

1. Update iOS app to use these endpoints
2. Add more API endpoints for activities
3. Deploy to production server (Heroku, Railway, etc.)
4. Set up production database
5. Implement rate limiting
6. Add email verification (optional)
7. Add password reset flow (optional)

## Troubleshooting

### PostgreSQL Connection Failed

1. Make sure Docker is running: `docker ps`
2. Check if container is running: `docker-compose ps`
3. View logs: `docker-compose logs postgres`
4. Restart: `docker-compose down && docker-compose up -d`

### Port 5432 Already in Use

Change the port in `docker-compose.yml`:
```yaml
ports:
  - "5433:5432"  # Use 5433 instead
```

Then update `.env`:
```
DB_PORT=5433
```

### "database "moa_db" does not exist"

This means the init.sql didn't run. Try:
```bash
docker-compose down -v
docker-compose up -d
```

## Production Deployment

Before deploying to production:

1. Change `JWT_SECRET` to a strong random key
2. Set `NODE_ENV=production`
3. Update `DB_PASSWORD` to a secure password
4. Use a managed PostgreSQL service (AWS RDS, DigitalOcean, etc.)
5. Enable HTTPS
6. Add rate limiting
7. Add request validation
8. Set appropriate CORS origins
