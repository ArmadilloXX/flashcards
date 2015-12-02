redis_url = ENV["REDISTOGO_URL"] || "redis://127.0.0.1:6379/0/flashcards"
Flashcards::Application.config.cache_store = :redis_store,
                                             redis_url,
                                             { expires_in: 1.day }