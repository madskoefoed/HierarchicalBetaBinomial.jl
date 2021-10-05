
function simulate(μ = 0.5, ϕ = 0.5, n::Vector{<:Integer})

    @assert all(n .> 0) "All nᵢ must be strictly positive for i = 1,...,N"
    N = length(n)

    x = zeros(Integer, N)
    θ = zeros(N)
    for i in 1:N
        θ[i] = rand(Beta(μ, ϕ))
        x[i] = rand(Binomial(n[i], θ[i]))
    end
    return (x, θ)
end

simulate(0.5, 0.5, [10, 20, 15, 12, 18])