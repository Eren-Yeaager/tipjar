import Link from "next/link";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { ArrowRight, Coins, Users, Zap, Shield } from "lucide-react";

export default function Home() {
  return (
    <main className="min-h-screen bg-gradient-to-b from-gray-50 to-white">
      {/* Navigation */}
      <nav className="border-b bg-white/80 backdrop-blur-sm sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center">
              <h1 className="text-2xl font-bold text-gray-900">TipJar</h1>
            </div>
            <ConnectButton />
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
        <div className="text-center">
          <h1 className="text-5xl md:text-6xl font-bold text-gray-900 mb-6">
            Decentralized Tipping
            <br />
            <span className="text-blue-600">on Base</span>
          </h1>
          <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
            Support creators with instant, on-chain tips. Automatic splits, transparent payments,
            zero custody.
          </p>
          <div className="flex gap-4 justify-center">
            <Button asChild size="lg" className="text-lg px-8">
              <Link href="/u/test-jar-1">
                Try it Now
                <ArrowRight className="ml-2 h-5 w-5" />
              </Link>
            </Button>
            <Button asChild size="lg" variant="outline" className="text-lg px-8">
              <Link href="#how-it-works">Learn More</Link>
            </Button>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
        <h2 className="text-3xl font-bold text-center mb-12">Why TipJar?</h2>
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
          <Card>
            <CardHeader>
              <Zap className="h-10 w-10 text-blue-600 mb-4" />
              <CardTitle>Instant Payments</CardTitle>
              <CardDescription>
                Tips are split and paid instantly on-chain. No waiting.
              </CardDescription>
            </CardHeader>
          </Card>

          <Card>
            <CardHeader>
              <Users className="h-10 w-10 text-blue-600 mb-4" />
              <CardTitle>Split to Multiple</CardTitle>
              <CardDescription>
                Automatically split tips among up to 5 beneficiaries.
              </CardDescription>
            </CardHeader>
          </Card>

          <Card>
            <CardHeader>
              <Shield className="h-10 w-10 text-blue-600 mb-4" />
              <CardTitle>Trustless & Secure</CardTitle>
              <CardDescription>
                Smart contracts ensure transparent, verifiable splits.
              </CardDescription>
            </CardHeader>
          </Card>

          <Card>
            <CardHeader>
              <Coins className="h-10 w-10 text-blue-600 mb-4" />
              <CardTitle>ETH & USDC</CardTitle>
              <CardDescription>Accept tips in ETH or USDC on Base network.</CardDescription>
            </CardHeader>
          </Card>
        </div>
      </section>

      {/* How It Works Section */}
      <section
        id="how-it-works"
        className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 bg-gray-50"
      >
        <h2 className="text-3xl font-bold text-center mb-12">How It Works</h2>
        <div className="grid md:grid-cols-3 gap-8">
          <div className="text-center">
            <div className="bg-blue-600 text-white rounded-full w-16 h-16 flex items-center justify-center text-2xl font-bold mx-auto mb-4">
              1
            </div>
            <h3 className="text-xl font-semibold mb-2">Create Your Jar</h3>
            <p className="text-gray-600">
              Set up your tip jar with beneficiaries and split percentages.
            </p>
          </div>

          <div className="text-center">
            <div className="bg-blue-600 text-white rounded-full w-16 h-16 flex items-center justify-center text-2xl font-bold mx-auto mb-4">
              2
            </div>
            <h3 className="text-xl font-semibold mb-2">Share Your Link</h3>
            <p className="text-gray-600">Share your unique jar link with supporters and fans.</p>
          </div>

          <div className="text-center">
            <div className="bg-blue-600 text-white rounded-full w-16 h-16 flex items-center justify-center text-2xl font-bold mx-auto mb-4">
              3
            </div>
            <h3 className="text-xl font-semibold mb-2">Receive Tips</h3>
            <p className="text-gray-600">
              Get tipped instantly. Funds split automatically on-chain.
            </p>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
        <div className="bg-blue-600 rounded-2xl p-12 text-center text-white">
          <h2 className="text-3xl font-bold mb-4">Ready to get started?</h2>
          <p className="text-xl mb-8 opacity-90">
            Create your tip jar in minutes and start receiving tips today.
          </p>
          <Button asChild size="lg" variant="secondary" className="text-lg px-8">
            <Link href="/u/test-jar-1">
              View Example Jar
              <ArrowRight className="ml-2 h-5 w-5" />
            </Link>
          </Button>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
          <div className="text-center text-gray-600">
            <p className="mb-2">Built on Base • Powered by Smart Contracts</p>
            <p className="text-sm">No custody • Transparent • Decentralized</p>
          </div>
        </div>
      </footer>
    </main>
  );
}
