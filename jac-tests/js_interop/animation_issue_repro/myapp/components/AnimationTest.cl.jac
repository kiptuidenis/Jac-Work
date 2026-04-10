"""Animation test component using GSAP and Framer Motion."""

import from gsap { gsap }
import from "gsap/ScrollTrigger" { ScrollTrigger }
import from "@gsap/react" { useGSAP }
import from "framer-motion" { motion }


def:pub AnimationTest() -> Any {
    # Using @gsap/react's useGSAP hook
    useGSAP(lambda -> None {
        gsap.registerPlugin(ScrollTrigger);
        gsap.to(".box", {
            "x": 200,
            "rotation": 360,
            "duration": 2,
            "scrollTrigger": {
                "trigger": ".box",
                "start": "top center",
                "end": "bottom center",
                "scrub": True
            }
        });
    }, []);

    return <div style={{"padding": "50px", "minHeight": "200vh"}}>
        <h2>Animation Interop Test</h2>
        <p>Scroll down to see GSAP ScrollTrigger in action.</p>
        
        <div className="box" style={{"width": "100px", "height": "100px", "background": "red", "display": "flex", "alignItems": "center", "justifyContent": "center", "color": "white", "fontWeight": "bold"}}>
            GSAP
        </div>

        <motion.div
            initial={{"opacity": 0, "scale": 0.5}}
            animate={{"opacity": 1, "scale": 1}}
            transition={{"duration": 2}}
            style={{"width": "100px", "height": "100px", "background": "blue", "marginTop": "20px", "display": "flex", "alignItems": "center", "justifyContent": "center", "color": "white", "fontWeight": "bold"}}
        >
            Motion
        </motion.div>
    </div>;
}
