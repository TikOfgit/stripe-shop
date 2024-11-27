import { useState } from 'react'
import { loadStripe } from '@stripe/stripe-js'

const stripePromise = loadStripe(import.meta.env.VITE_STRIPE_PUBLIC_KEY)

const product = {
  name: "Premium Headphones",
  description: "High-quality wireless headphones with noise cancellation",
  price: 199.99,
  image: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500"
}

function App() {
  const handleCheckout = async () => {
    try {
      const stripe = await stripePromise
      const response = await fetch('/api/create-checkout-session', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ product }),
      })

      if (!response.ok) {
        throw new Error('Network response was not ok')
      }

      const data = await response.json()
      
      const result = await stripe.redirectToCheckout({
        sessionId: data.id,
      })

      if (result.error) {
        console.error(result.error)
      }
    } catch (error) {
      console.error('Error:', error)
    }
  }

  return (
    <div className="min-h-screen bg-gray-100">
      <header className="bg-white shadow">
        <div className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
          <h1 className="text-3xl font-bold text-gray-900">Notre Boutique Audio</h1>
        </div>
      </header>

      <main className="flex-1">
        <div className="max-w-7xl mx-auto py-12 px-4 sm:px-6 lg:px-8">
          <div className="max-w-md mx-auto bg-white rounded-xl shadow-md overflow-hidden md:max-w-2xl">
            <div className="md:flex">
              <div className="md:shrink-0">
                <img className="h-48 w-full object-cover md:h-full md:w-48" src={product.image} alt={product.name} />
              </div>
              <div className="p-8">
                <div className="uppercase tracking-wide text-sm text-indigo-500 font-semibold">{product.name}</div>
                <p className="mt-2 text-slate-500">{product.description}</p>
                <div className="mt-4">
                  <span className="text-2xl font-bold">{product.price}€</span>
                </div>
                <button
                  onClick={handleCheckout}
                  className="mt-4 w-full bg-indigo-600 text-white py-2 px-4 rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
                >
                  Acheter maintenant
                </button>
              </div>
            </div>
          </div>
        </div>
      </main>

      <footer className="bg-white">
        <div className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
          <p className="text-center text-gray-500"> 2024 Notre Boutique Audio. Tous droits réservés.</p>
        </div>
      </footer>
    </div>
  )
}

export default App
