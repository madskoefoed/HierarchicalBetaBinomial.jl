
mutable struct Data{T<:Integer}
    x::Vector{T}
    n::Vector{T}
    function Data(x::Vector{T}, n::Vector{T}) where T<:Integer
        @assert length(x) == length(n) "Inputs x and n must have the same length."
        @assert all(x .<= n) "xᵢ <= nᵢ for all elements i = 1,...,N"
        @assert all(x .>= 0) "xᵢ >= 0 for all elements i = 1,...,N"
        new{T}(x, n)
    end
end

mutable struct Prior{T<:AbstractFloat}
    μ::Beta
    σ::Beta
end

struct Posterior{T<:AbstractFloat}
    μ::Vector{T}
    σ::Vector{T}
    θ::Matrix{T}
    acceptance::Matrix{<:Integer}
end

