import React from "react"

type HelloWorldProps = {
  greeting: string
}

export const HelloWorld = ({ greeting }: HelloWorldProps) => <p>
  TypeScript: {greeting}
</p>

export default HelloWorld;
