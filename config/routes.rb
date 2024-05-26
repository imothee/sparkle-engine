Twinkle::Engine.routes.draw do
  get 'updates/:slug' => 'appcast#show'
end
