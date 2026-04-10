"""Main entry point for myapp."""

# Client-side imports
cl import from react { useEffect }
cl import from .components.Button { Button }
cl import from .components.AnimationTest { AnimationTest }

# Testing cl import for subpaths in a .jac file
cl import from gsap { gsap }
cl import from "gsap/ScrollTrigger" { ScrollTrigger }
cl import from "@gsap/react" { useGSAP }
cl import from "framer-motion" { motion }

# Client-side component
cl {
    def:pub app() -> any {
        has count: int = 0;

        useEffect(lambda -> None {
            console.log("Count updated:", count);
        }, [count]);

        return <div style={{padding: "2rem", fontFamily: "Arial, sans-serif"}}>
            <h1>Hello, World!</h1>
            <p>Count: {count}</p>
            <div style={{display: "flex", gap: "1rem", marginTop: "1rem"}}>
                <Button
                    label="Increment"
                    onClick={lambda -> None { count = count + 1; }}
                    variant="primary"
                />
                <Button
                    label="Reset"
                    onClick={lambda -> None { count = 0; }}
                    variant="secondary"
                />
            </div>

            <hr style={{margin: "2rem 0"}} />
            
            <AnimationTest />
        </div>;
    }
}
