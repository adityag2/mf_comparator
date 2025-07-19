# 🚀 Mutual Fund Comparator

A high-performance, user-focused single-page web application (SPA) that compares Mutual Fund investments in Direct vs Regular plans with advanced analytics and modern UX.

## ✨ Features

### 🎯 Core Functionality
- **Fund Selection**: Dynamic dropdowns for Fund House and Fund selection
- **SIP Calculator**: Investment amount and duration inputs with real-time calculations
- **Smart Comparisons**: Direct vs Regular plan analysis with expense ratio differences
- **Interactive Charts**: Visual comparisons using Recharts
- **Multi-Fund Analysis**: Compare multiple funds simultaneously

### 📊 Advanced Analytics
- **Performance Metrics**: 5-year CAGR and historical returns
- **Expense Analysis**: Detailed expense ratio breakdown
- **Wealth Projections**: Final corpus calculations for both plans
- **Smart Summaries**: User-friendly insights like "💡 You'll earn ₹25,000 more by choosing Direct Plan"

### 🚀 Performance Features
- **In-Memory Caching**: Optimized fund data caching for faster lookups
- **Debounced Search**: Smooth search experience with minimal API calls
- **Lazy Loading**: Efficient fund list loading from API
- **Offline Support**: LocalStorage caching for repeat use

### 🎨 Modern UI/UX
- **Responsive Design**: Mobile-first approach with Tailwind CSS
- **Interactive Charts**: Recharts integration for data visualization
- **Smart Tagging**: Fund labels like "Low Expense" or "Below Category Avg"
- **Export Functionality**: PDF reports, CSV data, and social sharing

## 🛠️ Tech Stack

- **Frontend**: React 18 with Hooks
- **Styling**: Tailwind CSS
- **Charts**: Recharts
- **Icons**: Lucide React
- **Build Tool**: Create React App
- **Package Manager**: pnpm

## 📦 Installation

```bash
# Clone the repository
git clone <repository-url>
cd mf_comparator

# Install dependencies
pnpm install

# Start development server
pnpm start

# Build for production
pnpm build

# Preview production build
pnpm preview
```

## 🎯 Usage

1. **Select Fund House**: Choose from dropdown (HDFC, SBI, etc.)
2. **Choose Fund**: Select specific fund (e.g., HDFC Midcap Growth)
3. **Enter SIP Details**: Amount and investment period
4. **View Results**: Compare Direct vs Regular plans with charts
5. **Export/Share**: Generate reports or share comparisons

## 🏗️ Project Structure

```
src/
├── App.js                 # Main application component
├── index.js              # React entry point
├── styles.css            # Global styles
└── components/           # React components (if modularized)
    ├── FundSelector.js   # Fund selection dropdowns
    ├── SIPInputs.js      # Investment input fields
    ├── ResultsCard.js    # Calculation results display
    ├── ComparisonChart.js # Recharts visualization
    └── ExportPanel.js    # Export functionality
```

## 🔧 Configuration

### Deployment Platforms

#### Vercel
```json
// vercel.json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "Content-Type",
          "value": "application/vnd.ant.react"
        }
      ]
    }
  ]
}
```

#### Netlify
```toml
# netlify.toml
[[headers]]
  for = "/*"
  [headers.values]
    Content-Type = "application/vnd.ant.react"
```

#### Custom Server
```bash
# Start custom Express server
pnpm run serve
```

## 🚀 Deployment

### Vercel
```bash
vercel --prod
```

### Netlify
```bash
netlify deploy --prod
```

### Custom Server
```bash
pnpm run build
pnpm run serve
```

## 📈 Performance Optimizations

- **Memoization**: React.memo and useMemo for expensive calculations
- **Caching**: In-memory cache for fund data
- **Debouncing**: Search input optimization
- **Code Splitting**: Lazy loading for better initial load
- **Image Optimization**: Compressed assets and lazy loading

## 🎨 UI Components

### Fund Selector
- Dynamic dropdown with search
- Fund house categorization
- Smart tagging system

### SIP Calculator
- Amount and duration inputs
- Real-time calculations
- Validation and error handling

### Results Display
- Comparison cards
- Interactive charts
- Smart summaries

### Export Panel
- PDF generation
- CSV export
- Social sharing

## 🔮 Future Enhancements

### Phase 2 Roadmap
1. **Real API Integration**: Connect to actual mutual fund APIs
2. **Advanced Analytics**: Risk analysis, Sharpe ratio, volatility metrics
3. **Portfolio Builder**: Multi-fund SIP allocation with rebalancing
4. **Goal-Based Planning**: Retirement, education, house purchase calculators
5. **Enhanced UX**: Dark mode, animations, better mobile experience
6. **Data Features**: Historical performance, fund manager analysis
7. **Alert System**: Price alerts, performance notifications

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details

## 🆘 Support

For issues and questions:
- Create an issue in the repository
- Check the documentation
- Review the code comments

---

**Built with ❤️ for better investment decisions**
