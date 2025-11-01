"use client";

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { SelectContent, SelectItem } from "@/components/ui/select";
import { CHAIN_ID } from "@/lib/contracts";
import { Label } from "@/components/ui/label";
import { SelectArrow } from "@radix-ui/react-select";
import { Select, SelectTrigger, SelectValue } from "@/components/ui/select";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import { ArrowLeft, Cone } from "lucide-react";
import Link from "next/link";
import { use, useState } from "react";
import { useAccount, useChainId } from "wagmi";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

export default function TipJarPage({ params }: { params: Promise<{ handle: string }> }) {
  const { handle } = use(params);
  const [token, setToken] = useState("ETH");
  const [tipAmount, setTipAmount] = useState("");
  const [isTipping, setIsTipping] = useState(false);
  const chainId = useChainId();
  const { address, isConnected } = useAccount();
  const isCorrectNetwork = chainId === CHAIN_ID;

  const handleTip = async () => {
    if (!isConnected || !isCorrectNetwork) return;
    if (!tipAmount || parseFloat(tipAmount) <= 0) return;
    setIsTipping(true);
    alert(`Tip of ${tipAmount} ${token} will be implemented next`);
    setIsTipping(false);
  };

  return (
    <main className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <nav className="border-b bg-white dark:bg-gray-800 sticky top-0 z-50">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <Link href="/" className="flex items-center gap-2 text-gray-600 dark:text-gray-300">
              <ArrowLeft className="h-5 w-5" />
              <span>Back</span>
            </Link>
            <ConnectButton />
          </div>
        </div>
      </nav>

      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="mb-8 text-center">
          <h1 className="text-4xl font-bold mb-2 text-gray-900 dark:text-white">@{handle}</h1>
          <p className="text-gray-600 dark:text-gray-400">Support this creator with a tip </p>
        </div>

        {isConnected && !isCorrectNetwork && (
          <Card className="mb-6 border-yellow-500 bg-yellow-50 dark:bg-yellow-900/20">
            <CardContent className="pt-6">
              <p className="text-yellow-800 dark:text-yellow-200">
                ⚠️ Please switch to Base Sepolia testnet to tip
              </p>
            </CardContent>
          </Card>
        )}
        <div className="grid md:grid-cols-2 gap-8">
          <Card>
            <CardHeader>
              <CardTitle>Send a Tip</CardTitle>
              <CardDescription>Choose amount and token to tip</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="token">Token</Label>
                <Select value={token} onValueChange={setToken}>
                  <SelectTrigger id="token">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="ETH">ETH</SelectItem>
                    <SelectItem value="USDC">USDC (Coming soon)</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label htmlFor="amount">Amount</Label>
                <Input
                  id="amount"
                  type="number"
                  placeholder="0.01"
                  value={tipAmount}
                  onChange={(e) => setTipAmount(e.target.value)}
                  min="0"
                  step="0.001"
                />
              </div>
              {!isConnected ? (
                <div className="pt-4">
                  <ConnectButton.Custom>
                    {({ account, chain, openConnectModal }) => (
                      <Button onClick={openConnectModal} className="w-full">
                        Connect Wallet to Tip
                      </Button>
                    )}
                  </ConnectButton.Custom>
                </div>
              ) : (
                <Button
                  onClick={handleTip}
                  disabled={
                    !isTipping || parseFloat(tipAmount) <= 0 || !isCorrectNetwork || isTipping
                  }
                  className="w-full"
                >
                  {isTipping ? "Sending ..." : "Send Tip"}
                </Button>
              )}
              {isConnected && tipAmount && parseFloat(tipAmount) > 0 && (
                <div className="pt-4 space-y-2 text-sm text-gray-600 dark:text-gray-400 ">
                  <div className="flex justify-between">
                    <span> Your Tip : </span>
                    <span className="font-medium">
                      {tipAmount} {token}
                    </span>
                  </div>
                  <div className="text-xs text-gray-500 dark:text-gray-500">
                    * Split preview will be shown here once we connect to contracts
                  </div>
                </div>
              )}
            </CardContent>
          </Card>
          <Card>
            <CardHeader>
              <CardTitle>Jar Information</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div>
                <Label className="text-sm text-gray-600 dark:text-gray-400">Handle</Label>
                <p className="font-medium">@{handle}</p>
              </div>

              <div>
                <Label className="text-sm text-gray-600 dark:text-gray-400">Total Received</Label>
                <p className="font-medium">Loading...</p>
                <p className="text-xs text-gray-500 dark:text-gray-500">
                  * Will fetch from indexer
                </p>
              </div>

              <div>
                <Label className="text-sm text-gray-600 dark:text-gray-400">Top Supporters</Label>
                <p className="text-sm text-gray-500 dark:text-gray-500">Coming soon</p>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </main>
  );
}
