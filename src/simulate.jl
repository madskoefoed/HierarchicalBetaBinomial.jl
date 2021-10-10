
function simulate(b::Beta, n::Vector{<:Integer})
    @assert all(n .> 0) "All nᵢ must be strictly positive for i = 1,...,N"
    N = length(n)

    x = zeros(Integer, N)
    θ = zeros(N)
    for i in 1:N
        θ[i] = rand(b)
        x[i] = rand(Binomial(n[i], θ[i]))
    end
    return (x = x, n = n, θ = θ)
end

n   = rand(1:100, 100)
sim = simulate(Beta(10, 30), n)