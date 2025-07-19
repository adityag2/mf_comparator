// Real Mutual Fund API Integration
const API_BASE_URL = window.location.origin + '/api';

class MutualFundAPI {
  constructor() {
    this.cache = new Map();
    this.cacheTimeout = 5 * 60 * 1000; // 5 minutes
  }

  // Cache management
  getCached(key) {
    const cached = this.cache.get(key);
    if (cached && Date.now() - cached.timestamp < this.cacheTimeout) {
      return cached.data;
    }
    return null;
  }

  setCache(key, data) {
    this.cache.set(key, {
      data,
      timestamp: Date.now()
    });
  }

  // Fetch all mutual funds
  async getAllFunds() {
    const cacheKey = 'all-funds';
    const cached = this.getCached(cacheKey);
    if (cached) return cached;

    try {
      const response = await fetch(`${API_BASE_URL}/mf`);
      if (!response.ok) throw new Error('Failed to fetch funds');
      
      const data = await response.json();
      this.setCache(cacheKey, data);
      return data;
    } catch (error) {
      console.error('API Error:', error);
      return this.getFallbackFunds();
    }
  }

  // Fetch fund details by scheme code
  async getFundDetails(schemeCode) {
    const cacheKey = `fund-${schemeCode}`;
    const cached = this.getCached(cacheKey);
    if (cached) return cached;

    try {
      const response = await fetch(`${API_BASE_URL}/mf/${schemeCode}`);
      if (!response.ok) throw new Error('Fund not found');
      
      const data = await response.json();
      this.setCache(cacheKey, data);
      return data;
    } catch (error) {
      console.error('API Error:', error);
      return null;
    }
  }

  // Get NAV history
  async getNAVHistory(schemeCode, days = 30) {
    const cacheKey = `nav-${schemeCode}-${days}`;
    const cached = this.getCached(cacheKey);
    if (cached) return cached;

    try {
      const response = await fetch(`${API_BASE_URL}/mf/${schemeCode}/latest`);
      if (!response.ok) throw new Error('NAV data not found');
      
      const data = await response.json();
      this.setCache(cacheKey, data);
      return data;
    } catch (error) {
      console.error('API Error:', error);
      return null;
    }
  }

  // Search funds by name
  async searchFunds(query) {
    const allFunds = await this.getAllFunds();
    if (!allFunds || !Array.isArray(allFunds)) return [];

    return allFunds.filter(fund => 
      fund.schemeName?.toLowerCase().includes(query.toLowerCase()) ||
      fund.schemeCode?.toString().includes(query)
    ).slice(0, 20); // Limit results
  }

  // Get fund houses
  async getFundHouses() {
    const allFunds = await this.getAllFunds();
    if (!allFunds || !Array.isArray(allFunds)) return [];

    const houses = new Set();
    allFunds.forEach(fund => {
      if (fund.schemeName) {
        const house = fund.schemeName.split(' ')[0];
        houses.add(house);
      }
    });

    return Array.from(houses).sort();
  }

  // Get funds by house
  async getFundsByHouse(houseName) {
    const allFunds = await this.getAllFunds();
    if (!allFunds || !Array.isArray(allFunds)) return [];

    return allFunds.filter(fund => 
      fund.schemeName?.startsWith(houseName)
    );
  }

  // Fallback data when API fails
  getFallbackFunds() {
    return [
      {
        schemeCode: "101206",
        schemeName: "HDFC Mid-Cap Opportunities Fund - Direct Plan - Growth",
        nav: "45.67",
        date: new Date().toISOString().split('T')[0]
      },
      {
        schemeCode: "101207", 
        schemeName: "SBI Blue Chip Fund - Direct Plan - Growth",
        nav: "52.34",
        date: new Date().toISOString().split('T')[0]
      }
    ];
  }
}

export default new MutualFundAPI(); 