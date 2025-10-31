// Root ESLint config for monorepo (ESLint v9 format)
export default [
  {
    ignores: [
      "**/node_modules/**",
      "**/dist/**",
      "**/build/**",
      "**/.next/**",
      "apps/web/**", // Web app has its own ESLint config
      "contracts/**", // Contracts use Forge/Solidity, not ESLint
    ],
  },
  {
    files: ["**/*.{js,jsx,ts,tsx}"],
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: "module",
      globals: {
        node: true,
      },
    },
    rules: {
      "no-console": "warn",
      "no-unused-vars": "off",
    },
  },
];
