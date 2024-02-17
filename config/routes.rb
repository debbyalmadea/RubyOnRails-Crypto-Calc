Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "home#index"

  # Defines the route for the Vigenere Cipher
  get "vigenere-cipher" => "vigenere_cipher#index"
  post "vigenere-cipher/calculate" => "vigenere_cipher#calculate"

  # Defines the route for the Autokey Vigenere Cipher
  get "autokey-vigenere-cipher" => "autokey_vigenere_cipher#index"
  post "autokey-vigenere-cipher/calculate" => "autokey_vigenere_cipher#calculate"

  # Defines the route for the Extended Vigenere Cipher
  get "extended-vigenere-cipher" => "extended_vigenere_cipher#index"
  post "extended-vigenere-cipher/calculate" => "extended_vigenere_cipher#calculate"

  # Defines the route for the Playfair Cipher
  get "playfair-cipher" => "playfair_cipher#index"
  post "playfair-cipher/calculate" => "playfair_cipher#calculate"

  # Defines the route for the Hill Cipher
  get "hill-cipher" => "hill_cipher#index"
  post "hill-cipher/calculate" => "hill_cipher#calculate"

  # Defines the route for the Super Encryption
  get "super-encryption" => "super_encryption#index"
  post "super-encryption/calculate" => "super_encryption#calculate"
end
