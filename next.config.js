/* eslint-disable import/no-extraneous-dependencies */
const withBundleAnalyzer = require('@next/bundle-analyzer')({
  enabled: process.env.ANALYZE === 'true',
});

/** @type {import('next').NextConfig} */
module.exports = withBundleAnalyzer({
  output: 'standalone',

  eslint: {
    ignoreDuringBuilds: true, // 🔐 IMPORTANT FOR DOCKER
  },

  poweredByHeader: false,
  reactStrictMode: true,
});
