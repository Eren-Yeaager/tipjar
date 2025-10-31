import { getDefaultConfig } from "@rainbow-me/rainbowkit";
import { baseSepolia } from "viem/chains";
import { CONTRACTS } from "./contracts";

export const wagmiConfig = getDefaultConfig({
  appName: "TipJar",
  projectId: process.env.NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID!,
  chains: [baseSepolia],
  ssr: true,
});
