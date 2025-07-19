const fs = require('fs');
const path = require('path');

// Serve static files from build directory
const serveStaticFile = (filePath, contentType) => {
  try {
    const fullPath = path.join(__dirname, 'build', filePath);
    const content = fs.readFileSync(fullPath, 'utf8');
    return {
      statusCode: 200,
      headers: {
        'Content-Type': contentType,
        'Cache-Control': 'public, max-age=31536000',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET, POST, OPTIONS'
      },
      body: content
    };
  } catch (error) {
    return {
      statusCode: 404,
      body: 'File not found'
    };
  }
};

// Get content type based on file extension
const getContentType = (filePath) => {
  const ext = path.extname(filePath).toLowerCase();
  const contentTypes = {
    '.html': 'text/html',
    '.js': 'application/javascript',
    '.css': 'text/css',
    '.json': 'application/json',
    '.png': 'image/png',
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.gif': 'image/gif',
    '.svg': 'image/svg+xml',
    '.ico': 'image/x-icon',
    '.woff': 'font/woff',
    '.woff2': 'font/woff2',
    '.ttf': 'font/ttf',
    '.eot': 'application/vnd.ms-fontobject'
  };
  return contentTypes[ext] || 'application/octet-stream';
};

// Main Lambda handler
exports.handler = async (event) => {
  const { httpMethod, path, pathParameters } = event;
  
  // Handle CORS preflight requests
  if (httpMethod === 'OPTIONS') {
    return {
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET, POST, OPTIONS'
      },
      body: ''
    };
  }

  // Handle API requests
  if (path.startsWith('/api/')) {
    return handleApiRequest(event);
  }

  // Handle static file requests
  let filePath = path;
  
  // Default to index.html for root path
  if (path === '/' || path === '') {
    filePath = '/index.html';
  }
  
  // Remove leading slash for file system
  if (filePath.startsWith('/')) {
    filePath = filePath.substring(1);
  }
  
  // Handle client-side routing - serve index.html for all routes
  if (!filePath.includes('.') || filePath.includes('..')) {
    filePath = 'index.html';
  }

  const contentType = getContentType(filePath);
  return serveStaticFile(filePath, contentType);
};

// Handle API requests to external mutual fund API
async function handleApiRequest(event) {
  const { path, queryStringParameters } = event;
  
  try {
    const apiPath = path.replace('/api', '');
    const apiUrl = `${process.env.API_BASE_URL}${apiPath}`;
    
    // Add query parameters if present
    const url = new URL(apiUrl);
    if (queryStringParameters) {
      Object.keys(queryStringParameters).forEach(key => {
        url.searchParams.append(key, queryStringParameters[key]);
      });
    }

    const response = await fetch(url.toString(), {
      headers: {
        'User-Agent': 'MF-Comparator/1.0',
        'Accept': 'application/json'
      }
    });

    if (!response.ok) {
      throw new Error(`API request failed: ${response.status}`);
    }

    const data = await response.json();

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET, POST, OPTIONS'
      },
      body: JSON.stringify(data)
    };
  } catch (error) {
    console.error('API Error:', error);
    
    return {
      statusCode: 500,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({
        error: 'Internal server error',
        message: error.message
      })
    };
  }
} 