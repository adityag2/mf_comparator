// Data transformer for converting API data to app format
export const transformFundData = (apiFunds) => {
  if (!Array.isArray(apiFunds)) return [];

  return apiFunds.map(fund => {
    const isDirect = fund.schemeName?.includes('Direct');
    const isRegular = fund.schemeName?.includes('Regular') || !isDirect;
    
    // Extract fund house and category
    const nameParts = fund.schemeName?.split(' ') || [];
    const fundHouse = nameParts[0] || 'Unknown';
    
    // Determine category based on fund name
    let category = 'Other';
    if (fund.schemeName?.includes('Large Cap')) category = 'Large Cap';
    else if (fund.schemeName?.includes('Mid Cap')) category = 'Mid Cap';
    else if (fund.schemeName?.includes('Small Cap')) category = 'Small Cap';
    else if (fund.schemeName?.includes('Flexi Cap')) category = 'Flexi Cap';
    else if (fund.schemeName?.includes('Multi Cap')) category = 'Multi Cap';

    // Estimate expense ratios (real data would come from separate API)
    const baseER = 1.5; // Base expense ratio
    const directER = isDirect ? baseER - 0.5 : baseER;
    const regularER = isRegular ? baseER + 0.5 : baseER;

    // Estimate CAGR (real data would come from historical NAV)
    const estimatedCAGR = 12 + Math.random() * 8; // 12-20% range

    return {
      id: fund.schemeCode,
      name: fund.schemeName,
      category,
      fundHouse,
      directER: parseFloat(directER.toFixed(2)),
      regularER: parseFloat(regularER.toFixed(2)),
      cagr5y: parseFloat(estimatedCAGR.toFixed(1)),
      nav: parseFloat(fund.nav || 0),
      date: fund.date,
      isDirect,
      isRegular
    };
  });
};

export const groupFundsByHouse = (transformedFunds) => {
  const grouped = {};
  
  transformedFunds.forEach(fund => {
    if (!grouped[fund.fundHouse]) {
      grouped[fund.fundHouse] = [];
    }
    grouped[fund.fundHouse].push(fund);
  });

  return grouped;
};

export const calculateFundMetrics = (fund, navHistory = []) => {
  if (!navHistory || navHistory.length < 2) {
    return {
      volatility: 0,
      maxDrawdown: 0,
      sharpeRatio: 0
    };
  }

  // Calculate returns
  const returns = [];
  for (let i = 1; i < navHistory.length; i++) {
    const return_ = ((navHistory[i].nav - navHistory[i-1].nav) / navHistory[i-1].nav) * 100;
    returns.push(return_);
  }

  // Calculate metrics
  const avgReturn = returns.reduce((sum, r) => sum + r, 0) / returns.length;
  const variance = returns.reduce((sum, r) => sum + Math.pow(r - avgReturn, 2), 0) / returns.length;
  const volatility = Math.sqrt(variance);
  
  // Sharpe ratio (simplified)
  const riskFreeRate = 6; // 6% risk-free rate
  const sharpeRatio = (avgReturn - riskFreeRate) / volatility;

  return {
    volatility: parseFloat(volatility.toFixed(2)),
    maxDrawdown: parseFloat(Math.min(...returns).toFixed(2)),
    sharpeRatio: parseFloat(sharpeRatio.toFixed(2))
  };
}; 