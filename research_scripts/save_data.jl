using Dates
using JSON
using Statistics

function save(args, data, name::String)
    z = map(x -> (x.time, x.gctime, x.memory, x.allocs), mean.(data))
    d = unzip(z)

    m = [
        "xses" => string.(args),
        "times" => d[1],
        "gctimes" => d[2],
        "memory" => d[3],
        "allocs" => d[4],
    ]
    
    display(m)

    file = "test_results/" *name * Dates.format(now(), dateformat"yyyymmdd_HH-MM-SS.sss") * ".json"

    open(file, "w") do f
        JSON.print(f, m)
    end
end

function save2(args, data, name::String)
    dt = map(x -> mean(data[x]), args)
    z = map(x -> (x.time, x.gctime, x.memory, x.allocs), dt)
    d = unzip(z)

    m = [
        "xses" => string.(args),
        "times" => d[1],
        "gctimes" => d[2],
        "memory" => d[3],
        "allocs" => d[4],
    ]
    
    display(m)

    file = "test_results/" *name * Dates.format(now(), dateformat"yyyymmdd_HH-MM-SS.sss") * ".json"

    open(file, "w") do f
        JSON.print(f, m)
    end
end

# Source - https://stackoverflow.com/a
# Posted by ivirshup, modified by community. See post 'Timeline' for change history
# Retrieved 2025-11-22, License - CC BY-SA 4.0

unzip(a) = map(x->getfield.(a, x), fieldnames(eltype(a)))


function join_groups(group)
    y = map(x -> x[2], group)
    z = map(x -> (x.time, x.gctime, x.memory, x.allocs), y)
    d = unzip(z)
    e = map(mean, d)

    std = std(d[1])
    return e
end

function save_group(args, group, name)
    a = map(x -> join_groups(group[x]), args)
    # sort!(a, by = x-> x[1])
    d = unzip(a)

    m = [
        "xses" => string.(args),
        "times" => d[1],
        "gctimes" => d[2],
        "memory" => d[3],
        "allocs" => d[4],
    ]
    
    display(m)

    file = "test_results/" *name * Dates.format(now(), dateformat"yyyymmdd_HH-MM-SS.sss") * ".json"

    open(file, "w") do f
        JSON.print(f, m)
    end
end