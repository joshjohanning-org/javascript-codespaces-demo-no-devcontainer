module.exports = {
  swcMinify: true,
  reactStrictMode: true,

  eslint: {
    // Warning: This allows production builds to successfully complete even if
    // your project has ESLint errors.
    ignoreDuringBuilds: true,
  },

  images: {
    domains: ['octodex.github.com'],
    disableStaticImages: true,
    minimumCacheTTL: 60
  }
}
