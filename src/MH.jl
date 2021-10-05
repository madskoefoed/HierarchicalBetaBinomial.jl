
function MH(data::Data, prior::Prior, candidate::Vector{<:Normal}, draws = 1_000)

    x, n = data.x, data.n
    J = length(x)

    # Prepare posterior
    post = Posterior(zeros(draws), zeros(draws), zeros(draws, N), zeros(draws, 2))

    # Starting values
    post.μ[1] = 0.5
    post.σ[1] = 0.5

    post.acceptance[1, :] = 1

    # Old posterior
    lp = logposterior(prior::Prior, post.μ[1], post.σ[1], x, n)

    for i in 2:draws

        ### MU ###

        # Candidate value for μ
        μ = rand(Normal(post.μ[i - 1], 0.5))

        # Candidate log-posterior
        lpc = logposterior(prior::Prior, μ, post.σ[i - 1], x, n)

        if (lpc - lp) > log(rand())
            post.μ[i] = μ
            post.acceptance[:, 1] = 1
        else
            post.μ[i] = post.μ[i - 1]
        end

        ### SIGMA ###

        # Candidate value for σ
        σ = rand(Normal(post.σ[i - 1], 0.5))

        # Candidate log-posterior
        lpc = logposterior(prior::Prior, post.μ[i - 1], σ, x, n)

        if (lpc - lp) > log(rand())
            post.σ[i] = σ
            post.acceptance[:, 2] = 1
        else
            post.σ[i] = post.σ[i - 1]
        end

        ### THETA ###
        for j in 1:J
            θ[i, j] = rand(Beta((1 - post.σ[i])/post.σ[i] * post.μ[i] + x[j], (1 - post.σ[i])/post.σ[i] * (1 - post.μ[i]) + n[j] - x[j]))
        end

    end
    return post
end

logprior(prior::Beta, value::AbstractFloat) = (prior.α - 1)*log(value) + (prior.β - 1)*log(1 - value)
function loglikelihood(μ, σ, x, n)
    l = logpdf(Beta(μ * (1 - σ)/σ + x), (1 - μ)*(1 - σ)/σ + n - x)
    l = l - logpdf(Beta(μ * (1 - σ)/σ, (1 - μ)*(1 - σ)/σ)) * length(x)
    return l
end
function logposterior(prior::Prior, μ, σ, x, n)
    l = loglikelihood(μ, σ, x, n)
    p = logprior(prior.μ, μ) + logprior(prior.σ, σ)
    return l+p
end

